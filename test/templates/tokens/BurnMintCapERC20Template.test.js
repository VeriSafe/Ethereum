const { shouldBehaveLikeERC20Burnable } =   require('./behaviors/ERC20Burnable.behavior');
const {  shouldBehaveLikeERC20BDetailed } = require('./behaviors/ERC20Detailed.behavior');
const {  shouldBehaveLikeERC20Mintable } =  require('./behaviors/ERC20Mintable.behavior');
const {  shouldBehaveLikeERC20Capped } =  require('./behaviors/ERC20Capped.behavior');
const {  shouldBehaveLikePublicRole } =     require('../../access/PublicRole.behavior');
const BurnMintCapERC20Template = artifacts.require('BurnMintCapERC20Template');
const { ether } = require('../../helpers/ether');
contract('BurnMintCapERC20Template', function ([_, minter, otherMinter, owner, ...otherAccounts]) {
  const maxCap  = 2000;
  const _name = 'My Detailed ERC20';
  const _symbol = 'MDT';
  const _decimals = 18;

  beforeEach(async function () {
    this.token = await BurnMintCapERC20Template.new(_name, _symbol, _decimals, owner, maxCap, { from: minter });
  });
  

  shouldBehaveLikeERC20Burnable(owner, ether(maxCap), otherAccounts);
  shouldBehaveLikeERC20Capped(minter, otherAccounts, ether(maxCap));
  shouldBehaveLikeERC20BDetailed(_name, _symbol, _decimals);
  shouldBehaveLikeERC20Mintable(minter, otherAccounts);

});
