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

function shouldBehaveLikeTimedChangeCrowdsale(owner) {
    context('with Timed Change crowdsale', function () {
     
        it('sets new opening time', async function () {
           const newOpeningTime  = this.openingTime + time.duration.seconds(1);
           await this.crowdsale.setStartTime(newOpeningTime, {from:owner});
          (await this.crowdsale.openingTime()).should.be.bignumber.equal(newOpeningTime);
    
        });
        it('sets new close time', async function () {
          const newClosingTime  = this.closingTime + time.duration.seconds(10);
          await this.crowdsale.setEndTime(newClosingTime, {from:owner});
         (await this.crowdsale.closingTime()).should.be.bignumber.equal(newClosingTime);
        });
        it('sets new openint time and close time', async function () {
          const newClosingTime  = this.closingTime + time.duration.seconds(10);
          const newOpeningTime  = this.openingTime + time.duration.seconds(1);
          await this.crowdsale.setTimes(newOpeningTime, newClosingTime, {from:owner});
         (await this.crowdsale.closingTime()).should.be.bignumber.equal(newClosingTime);
         (await this.crowdsale.openingTime()).should.be.bignumber.equal(newOpeningTime);
        });
    
      });
}

module.exports = {
  shouldBehaveLikeTimedChangeCrowdsale,
};
