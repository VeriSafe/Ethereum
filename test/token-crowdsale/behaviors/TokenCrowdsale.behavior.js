const shouldFail = require('../../helpers/shouldFail');
const expectEvent = require('../../helpers/expectEvent');
const { ZERO_ADDRESS } = require('../../helpers/constants');
const { advanceBlock } = require('../../helpers/advanceToBlock');
const time = require('../../helpers/time');
const { ether } = require('../../helpers/ether');
const { ethGetBalance } = require('../../helpers/web3');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeTokenCrowdsale (investor, purchaser, tokenSupply, wallet, rate, value) {
    const expectedTokenAmount = rate.mul(value);
    context('With Token base Crowdsale', async function () {
          before(async function () {
            // Advance to the next block to correctly read time in the solidity "now" function interpreted by ganache
            await advanceBlock();
          });
          beforeEach(async function () {
            await time.increaseTo(this.openingTime);
          });
  
        describe('accepting payments', function () {
          describe('buyTokens', function () {
            beforeEach(async function () {
              await this.tokenExchange.approve(this.crowdsale.address, value, {  from: investor });
            });

            it('crowdsale allowed to do payments', async function () {
              await  this.tokenExchange.allowance(investor, this.crowdsale.address, {  from: purchaser });
            });

            it('should accept payments', async function () {
              await this.crowdsale.buyTokens(investor, value, {  from:  purchaser });
            });
  
            it('reverts on zero-valued payments', async function () {
              await shouldFail.reverting(
                this.crowdsale.buyTokens(investor, 0, {from: investor })
              );
            });
  
            it('requires a non-null beneficiary', async function () {
              await shouldFail.reverting(
                this.crowdsale.buyTokens(ZERO_ADDRESS, 0, { from:investor })
              );
            });
          });
        });
  
      });
}

module.exports = {
  shouldBehaveLikeTokenCrowdsale,
};
