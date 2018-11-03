const { ether } = require('../../helpers/ether');
const { advanceBlock } = require('../../helpers/advanceToBlock');
const shouldFail = require('../../helpers/shouldFail');
const time = require('../../helpers/time');
const { ethGetBalance } = require('../../helpers/web3');
const expectEvent = require('../../helpers/expectEvent');

const {  shouldBehaveLikeCrowdsale } = require('./behaviors/Crowdsale.behavior');
const {  shouldBehaveLikeTimedCrowdsale } = require('./behaviors/TimedCrowdsale.behavior');
const {  shouldBehaveLikeTimedChangeCrowdsale } = require('./behaviors/TimedChangeCrowdsale.behavior');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const TimedChangeCrowdsaledMock = artifacts.require('TimedChangeCrowdsaledMock');

const BurnERC20Template = artifacts.require('BurnERC20Template');

contract('TimedChangeCrowdsaledMock', function ([_, wallet, investor, purchaser, owner, anyone]) {
  const rate = new BigNumber(1);
  const goal = ether(50);
  const lessThanGoal = ether(45);
  const hardGoal = ether(300);
  const lessThanHardGoal = ether(250);
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

  context('with Template crowdsale', function () {
    beforeEach(async function () {
     
        this.crowdsale = await TimedChangeCrowdsaledMock.new(
          this.openingTime, this.closingTime, rate, wallet, this.token.address, { from: owner }
        );
      
      
      

      await this.token.transfer(this.crowdsale.address, tokenSupply, { from: owner } );
    });

    shouldBehaveLikeTimedCrowdsale(investor, purchaser,  value);
    shouldBehaveLikeTimedChangeCrowdsale(owner);

    context('after opening time', function () {
      beforeEach(async function () {
        await time.increaseTo(this.openingTime);
      });
      shouldBehaveLikeCrowdsale(investor, purchaser, tokenSupply, wallet, rate, value);
    });
   });
  
});
