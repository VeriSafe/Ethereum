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

function shouldBehaveLikeCrowdsale (investor, purchaser, tokenSupply, wallet, rate, value) {
    const expectedTokenAmount = rate.mul(value);
    context('With base Crowdsale', async function () {
        before(async function () {
            // Advance to the next block to correctly read time in the solidity "now" function interpreted by ganache
            await advanceBlock();
          });
          beforeEach(async function () {
            await time.increaseTo(this.openingTime);
          });
  
        describe('accepting payments', function () {
          describe('bare payments', function () {
            it('should accept payments', async function () {
              await this.crowdsale.send(value, { from: purchaser });
            });
  
            it('reverts on zero-valued payments', async function () {
              await shouldFail.reverting(
                this.crowdsale.send(0, { from: purchaser })
              );
            });
          });
  
          describe('buyTokens', function () {
            it('should accept payments', async function () {
              await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
            });
  
            it('reverts on zero-valued payments', async function () {
              await shouldFail.reverting(
                this.crowdsale.buyTokens(investor, { value: 0, from: purchaser })
              );
            });
  
            it('requires a non-null beneficiary', async function () {
              await shouldFail.reverting(
                this.crowdsale.buyTokens(ZERO_ADDRESS, { value: value, from: purchaser })
              );
            });
          });
        });
        // This part is tested in PostDelivery Crowdsale
        /*describe('high-level purchase', function () {
          it('should log purchase', async function () {
            const { logs } = await this.crowdsale.sendTransaction({ value: value, from: investor });
            expectEvent.inLogs(logs, 'TokensPurchased', {
              purchaser: investor,
              beneficiary: investor,
              value: value,
              amount: expectedTokenAmount,
            });
          });
  
          it('should assign tokens to sender', async function () {
            await this.crowdsale.sendTransaction({ value: value, from: investor });
            (await this.token.balanceOf(investor)).should.be.bignumber.equal(expectedTokenAmount);
          });
  
          it('should forward funds to wallet', async function () {
            const pre = await ethGetBalance(wallet);
            await this.crowdsale.sendTransaction({ value, from: investor });
            const post = await ethGetBalance(wallet);
            post.minus(pre).should.be.bignumber.equal(value);
          });
        });*/
  
       /* describe('low-level purchase', function () {
          it('should log purchase', async function () {
            const { logs } = await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
            expectEvent.inLogs(logs, 'TokensPurchased', {
              purchaser: purchaser,
              beneficiary: investor,
              value: value,
              amount: expectedTokenAmount,
            });
          });
  
          it('should assign tokens to beneficiary', async function () {
            await this.crowdsale.buyTokens(investor, { value, from: purchaser });
            (await this.token.balanceOf(investor)).should.be.bignumber.equal(expectedTokenAmount);
          });
  
          it('should forward funds to wallet', async function () {
            const pre = await ethGetBalance(wallet);
            await this.crowdsale.buyTokens(investor, { value, from: purchaser });
            const post = await ethGetBalance(wallet);
            post.minus(pre).should.be.bignumber.equal(value);
          });
        });*/



      });
}

module.exports = {
  shouldBehaveLikeCrowdsale,
};
