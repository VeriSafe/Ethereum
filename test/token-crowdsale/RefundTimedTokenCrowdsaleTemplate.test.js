const { ether } = require('../helpers/ether');
const { advanceBlock } = require('../helpers/advanceToBlock');
const shouldFail = require('../helpers/shouldFail');
const time = require('../helpers/time');
const { ethGetBalance } = require('../helpers/web3');
const expectEvent = require('../helpers/expectEvent');
const {  shouldBehaveLikeTokenCrowdsale } = require('./behaviors/TokenCrowdsale.behavior');
const {  shouldBehaveLikeTokenFinalizableCrowdsale } = require('./behaviors/TokenFinalizableCrowdsale.behavior');
const {  shouldBehaveLikeTokenPostDeliveryCrowdsale } = require('./behaviors/TokenPostDeliveryCrowdsale.behavior');
const {  shouldBehaveLikeTokenRefundableCrowdsale } = require('./behaviors/TokenRefundableCrowdsale.behavior');
const {  shouldBehaveLikeTokenCappedCrowdsale } = require('./behaviors/TokenCappedCrowdsale.behavior');
const {  shouldBehaveLikeTokenTimedCrowdsale } = require('./behaviors/TokenTimedCrowdsale.behavior');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const RefundTimedTokenCrowdsaleTemplate = artifacts.require('RefundTimedTokenCrowdsaleTemplate');
const BurnERC20Template = artifacts.require('BurnERC20Template');

contract('RefundableTimedTokenCrowdsale', function ([_, wallet, investor, purchaser, owner, anyone]) {
  const rate = new BigNumber(1);
  const goal = ether(50);
  const lessThanGoal = ether(45);
  const hardGoal = ether(300);
  const lessThanHardGoal = ether(250);
  const value = ether(42);
  const initialBalance = 100000;
  const tokenSupply = ether(initialBalance);
  const _name = 'My Detailed ERC20';
  const _symbol = 'MDT';
  const _decimals = 18;
  const _nameExchanged = 'My Exchanged ERC20';
  const _symbolExchanged = 'MET';


  before(async function () {
    // Advance to the next block to correctly read time in the solidity "now" function interpreted by ganache
    await advanceBlock();
  });

  beforeEach(async function () {
    
    this.openingTime = (await time.latest()) + time.duration.weeks(1);
    this.closingTime = this.openingTime + time.duration.weeks(1);
    this.afterClosingTime = this.closingTime + time.duration.seconds(1);
    this.preWalletBalance = ether(0);
    this.token = await BurnERC20Template.new(_name, _symbol, _decimals, owner, initialBalance, { from: owner });
    this.tokenExchange = await BurnERC20Template.new(_nameExchanged, _symbolExchanged, _decimals, owner, initialBalance, { from: owner });;
    this.tokenExchange.transfer(investor, tokenSupply, {from:owner});
  });

  it('rejects a goal of zero', async function () {
    await shouldFail.reverting(
      RefundTimedTokenCrowdsaleTemplate.new(this.openingTime, this.closingTime, rate, wallet, this.token.address, this.tokenExchange.address, 0, 1)
    );
  });
  context('with Template crowdsale', function () {
    beforeEach(async function () {
      this.crowdsale = await RefundTimedTokenCrowdsaleTemplate.new(
        this.openingTime, this.closingTime, rate, wallet, this.token.address, this.tokenExchange.address, goal, hardGoal
      );

      await this.token.transfer(this.crowdsale.address, tokenSupply, { from: owner } );
    });

    shouldBehaveLikeTokenFinalizableCrowdsale(anyone);
    shouldBehaveLikeTokenPostDeliveryCrowdsale(investor, purchaser, tokenSupply, value);
    shouldBehaveLikeTokenRefundableCrowdsale (investor, lessThanGoal, goal, wallet, anyone);
    shouldBehaveLikeTokenTimedCrowdsale(investor, purchaser,  value);

    context('after opening time', function () {
      beforeEach(async function () {
        await time.increaseTo(this.openingTime);
      });
      shouldBehaveLikeTokenCrowdsale(investor, purchaser, tokenSupply, wallet, rate, value);
      shouldBehaveLikeTokenCappedCrowdsale(investor, hardGoal, lessThanHardGoal);
    });

   });



  
});
