const { shouldBehaveLikeERC20Burnable } = require('./behaviors/ERC20Burnable.behavior');
const {  shouldBehaveLikeERC20BDetailed } = require('./behaviors/ERC20Detailed.behavior');
const BurnERC20Template = artifacts.require('BurnERC20Template');
const { ether } = require('../../helpers/ether');
contract('BurnERC20Template', function ([_, owner, ...otherAccounts]) {
  const initialBalance = 1000;
  const _name = 'My Detailed ERC20';
  const _symbol = 'MDT';
  const _decimals = 18;

  beforeEach(async function () {
    this.token = await BurnERC20Template.new(_name, _symbol, _decimals, owner, initialBalance, { from: owner });
  });

  shouldBehaveLikeERC20Burnable(owner, ether(initialBalance), otherAccounts);
  shouldBehaveLikeERC20BDetailed(_name, _symbol, _decimals);

});
