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

function shouldBehaveLikeTimedCrowdsale (investor, purchaser,  value) {
    context('with Timed crowdsale', function () {
     
        it('should be ended only after end', async function () {
          (await this.crowdsale.hasClosed()).should.equal(false);
          await time.increaseTo(this.afterClosingTime);
          (await this.crowdsale.isOpen()).should.equal(false);
          (await this.crowdsale.hasClosed()).should.equal(true);
        });
    
        describe('accepting payments', function () {
          it('should reject payments before start', async function () {
            (await this.crowdsale.isOpen()).should.equal(false);
            await shouldFail.reverting(this.crowdsale.send(value));
            await shouldFail.reverting(this.crowdsale.buyTokens(investor, { from: purchaser, value: value }));
          });
    
          it('should accept payments after start', async function () {
            await time.increaseTo(this.openingTime);
            (await this.crowdsale.isOpen()).should.equal(true);
            await this.crowdsale.send(value);
            await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
          });
    
          it('should reject payments after end', async function () {
            await time.increaseTo(this.afterClosingTime);
            await shouldFail.reverting(this.crowdsale.send(value));
            await shouldFail.reverting(this.crowdsale.buyTokens(investor, { value: value, from: purchaser }));
          });
        });
      });
}

module.exports = {
  shouldBehaveLikeTimedCrowdsale,
};
