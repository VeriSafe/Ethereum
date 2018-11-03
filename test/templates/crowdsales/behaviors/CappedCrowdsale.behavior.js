const shouldFail = require('../../../helpers/shouldFail');
const expectEvent = require('../../../helpers/expectEvent');
const { ZERO_ADDRESS } = require('../../../helpers/constants');
const { advanceBlock } = require('../../../helpers/advanceToBlock');
const time = require('../../../helpers/time');
const { ether } = require('../../../helpers/ether');
const { ethGetBalance } = require('../../../helpers/web3');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeCappedCrowdsale(cap, lessThanCap) {
    context('With Capped crowdsale', function () {
      
        describe('accepting payments', function () {
          it('should accept payments within cap', async function () {
            await this.crowdsale.send(cap.minus(lessThanCap));
            await this.crowdsale.send(lessThanCap);
          });
    
          it('should reject payments outside cap', async function () {
            await this.crowdsale.send(cap);
            await shouldFail.reverting(this.crowdsale.send(1));
          });
    
          it('should reject payments that exceed cap', async function () {
            await shouldFail.reverting(this.crowdsale.send(cap.plus(1)));
          });
        });
    
        describe('ending', function () {
          it('should not reach cap if sent under cap', async function () {
            await this.crowdsale.send(lessThanCap);
            (await this.crowdsale.capReached()).should.equal(false);
          });
    
          it('should not reach cap if sent just under cap', async function () {
            await this.crowdsale.send(cap.minus(1));
            (await this.crowdsale.capReached()).should.equal(false);
          });
    
          it('should reach cap if cap sent', async function () {
            await this.crowdsale.send(cap);
            (await this.crowdsale.capReached()).should.equal(true);
          });
        });
      });
}

module.exports = {
    shouldBehaveLikeCappedCrowdsale,
};
