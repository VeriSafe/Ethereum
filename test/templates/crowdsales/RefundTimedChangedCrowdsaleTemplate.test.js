const { ether } = require('../../helpers/ether');
const { advanceBlock } = require('../../helpers/advanceToBlock');
const shouldFail = require('../../helpers/shouldFail');
const time = require('../../helpers/time');
const { ethGetBalance } = require('../../helpers/web3');
const expectEvent = require('../../helpers/expectEvent');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const RefundTimedChangedCrowdsaleTemplate = artifacts.require('RefundTimedChangedCrowdsaleTemplate');
const BurnERC20Template = artifacts.require('BurnERC20Template');

contract('RefundTimedChangedCrowdsaleTemplate', function ([_, wallet, investor, purchaser, owner, anyone]) {
  const rate = new BigNumber(1);
  const goal = ether(50);
  const lessThanGoal = ether(45);
  const hardGoal = ether(300);
  const value = ether(42);
  const tokenSupply = new BigNumber('1e22');
  const initialBalance = 100000;
  const _name = 'My Detailed ERC20';
  const _symbol = 'MDT';
  const _decimals = 18;

  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by ganache
    await advanceBlock();
  });

  beforeEach(async function () {
    this.openingTime = (await time.latest()) + time.duration.weeks(1);
    this.closingTime = this.openingTime + time.duration.weeks(1);
    this.afterClosingTime = this.closingTime + time.duration.seconds(1);
    this.preWalletBalance = await ethGetBalance(wallet);

    this.token = await BurnERC20Template.new(_name, _symbol, _decimals, owner, initialBalance, { from: owner });;
  });

  it('rejects a goal of zero', async function () {
    await shouldFail.reverting(
      RefundTimedChangedCrowdsaleTemplate.new(this.openingTime, this.closingTime, rate, wallet, this.token.address, 0, 1)
    );
  });

  context('with crowdsale', function () {
    beforeEach(async function () {
      this.crowdsale = await RefundTimedCrowdsaleTemplate.new(
        this.openingTime, this.closingTime, rate, wallet, this.token.address, goal, hardGoal
      );

      await this.token.transfer(this.crowdsale.address, tokenSupply, { from: owner } );
    });

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
          await this.crowdsale.sendTransaction({ value: lessThanGoal, from: investor });
        });

        context('after closing time and finalization', function () {
          beforeEach(async function () {
            await time.increaseTo(this.afterClosingTime);
            await this.crowdsale.finalize({ from: anyone });
          });

          it('refunds', async function () {
            const pre = await ethGetBalance(investor);
            await this.crowdsale.claimRefund(investor, { gasPrice: 0 });
            const post = await ethGetBalance(investor);
            post.minus(pre).should.be.bignumber.equal(lessThanGoal);
          });
        });
      });

      context('with reached goal', function () {
        beforeEach(async function () {
          await this.crowdsale.sendTransaction({ value: goal, from: investor });
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
            const postWalletBalance = await ethGetBalance(wallet);
            postWalletBalance.minus(this.preWalletBalance).should.be.bignumber.equal(goal);
          });
        });
      });
    });

    context('after opening time', function () {
      beforeEach(async function () {
        await time.increaseTo(this.openingTime);
      });
  
      context('with bought tokens', function () {
        const value = ether(42);
  
        beforeEach(async function () {
          await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
        });
  
        it('does not immediately assign tokens to beneficiaries', async function () {
          (await this.crowdsale.balanceOf(investor)).should.be.bignumber.equal(value);
          (await this.token.balanceOf(investor)).should.be.bignumber.equal(0);
        });
  
        it('does not allow beneficiaries to withdraw tokens before crowdsale ends', async function () {
          await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
        });
  
        context('after closing time', function () {
          beforeEach(async function () {
            await time.increaseTo(this.afterClosingTime);
          });
  
          it('allows beneficiaries to withdraw tokens', async function () {
            await this.crowdsale.withdrawTokens(investor);
            (await this.crowdsale.balanceOf(investor)).should.be.bignumber.equal(0);
            (await this.token.balanceOf(investor)).should.be.bignumber.equal(value);
          });
  
          it('rejects multiple withdrawals', async function () {
            await this.crowdsale.withdrawTokens(investor);
            await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
          });
        });
      });
    });
    it('cannot be finalized before ending', async function () {
      await shouldFail.reverting(this.crowdsale.finalize({ from: anyone }));
    });
  
    it('can be finalized by anyone after ending', async function () {
      await time.increaseTo(this.afterClosingTime);
      await this.crowdsale.finalize({ from: anyone });
    });
  
    it('cannot be finalized twice', async function () {
      await time.increaseTo(this.afterClosingTime);
      await this.crowdsale.finalize({ from: anyone });
      await shouldFail.reverting(this.crowdsale.finalize({ from: anyone }));
    });
  
    it('logs finalized', async function () {
      await time.increaseTo(this.afterClosingTime);
      const { logs } = await this.crowdsale.finalize({ from: anyone });
      expectEvent.inLogs(logs, 'CrowdsaleFinalized');
    });



  });
  
  
});
