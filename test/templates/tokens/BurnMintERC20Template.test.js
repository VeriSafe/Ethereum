const { shouldBehaveLikeERC20Burnable } = require('./behaviors/ERC20Burnable.behavior');
const {  shouldBehaveLikeERC20BDetailed } = require('./behaviors/ERC20Detailed.behavior');
const BurnMintERC20Template = artifacts.require('BurnMintERC20Template ');
const { ether } = require('../../helpers/ether');
contract('ERC20Burnable', function ([_, minter, otherMinter, owner, ...otherAccounts]) {
  const initialBalance = 1000;
  const _name = 'My Detailed ERC20';
  const _symbol = 'MDT';
  const _decimals = 18;

  beforeEach(async function () {
    this.token = await BurnMintERC20Template.new(_name, _symbol, _decimals, owner, initialBalance, { from: minter });
  });

  shouldBehaveLikeERC20Burnable(owner, ether(initialBalance), otherAccounts);
  shouldBehaveLikeERC20BDetailed(_name, _symbol, _decimals);
  shouldBehaveLikeERC20Mintable(minter, otherAccounts);
});
