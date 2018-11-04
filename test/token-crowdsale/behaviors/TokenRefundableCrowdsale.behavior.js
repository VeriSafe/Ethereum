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

  const Escrow = artifacts.require('TokenRefundEscrow');

function shouldBehaveLikeTokenRefundableCrowdsale (investor, lessThanGoal, goal, wallet, anyone) {
    context('with Refundable crowdsale', function () {
    
        context('before opening time', function () {
          it('denies refunds', async function () {
            await shouldFail.reverting(this.crowdsale.claimRefund(investor));
          });
        });
    
        context('after opening time', function () {
          beforeEach(async function () {
            await time.increaseTo(this.openingTime);
          });
    
          it('denies refunds', async function () {
            await shouldFail.reverting(this.crowdsale.claimRefund(investor));
          });
    
          context('with unreached goal', function () {
            beforeEach(async function () {
              const escrowAddress = await this.crowdsale.escrow();
              this.escrow = await Escrow.at(escrowAddress);
              await this.tokenExchange.approve(this.crowdsale.address, lessThanGoal, {from: investor});
              await this.crowdsale.buyTokens(investor, lessThanGoal, {  from: investor });
            });
    
            context('after closing time and finalization', function () {
              beforeEach(async function () {
                await time.increaseTo(this.afterClosingTime);
                await this.crowdsale.finalize({ from: anyone });
              });
              it('escrow have funds of investor', async function () {  
                (await this.tokenExchange.balanceOf(this.escrow.address)).should.be.bignumber.equal(lessThanGoal);
              });

              it('escrow have deposit funds of investor', async function () {  
                (await this.escrow.depositsOf(investor)).should.be.bignumber.equal(lessThanGoal);
              });
    
              it('refunds', async function () {
                const pre = await this.tokenExchange.balanceOf(investor);
                await this.crowdsale.claimRefund(investor, { gasPrice: 0 });
                const post = await this.tokenExchange.balanceOf(investor);
                post.minus(pre).should.be.bignumber.equal(lessThanGoal);
              });
            });
          });
    
          context('with reached goal', function () {
            beforeEach(async function () {
              await this.tokenExchange.approve(this.crowdsale.address, goal, {from: investor});
              await this.crowdsale.buyTokens(investor, goal, {  from: investor });
            });
    
            context('after closing time and finalization', function () {
              beforeEach(async function () {
                await time.increaseTo(this.afterClosingTime);
                await this.crowdsale.finalize({ from: anyone });
              });
    
              it('denies refunds', async function () {
                await shouldFail.reverting(this.crowdsale.claimRefund(investor));
              });
    
              it('forwards funds to wallet', async function () {
                const postWalletBalance = await this.tokenExchange.balanceOf(wallet);
                postWalletBalance.minus(this.preWalletBalance).should.be.bignumber.equal(goal);
              });
            });
          });
        });
    
      });
}

module.exports = {
    shouldBehaveLikeTokenRefundableCrowdsale,
};
