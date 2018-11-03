const { shouldBehaveLikeTokenAirdrop } = require('./behaviors/TokenAirdrop.behavior');
const ERC20Mock = artifacts.require('ERC20Mock');
const TokenAirdrop = artifacts.require('TokenAirdrop');
const { ether } = require('../helpers/ether');

contract('Airdrop', function ([_, primary, wallet, ...otherAccounts]) {
  beforeEach(async function () {
    const tokenSupply = ether(20000000000);
    this.token = await ERC20Mock.new(primary, tokenSupply,{from:primary});  
    this.airdrop = await TokenAirdrop.new(this.token.address, wallet, { from: primary });
  });

  shouldBehaveLikeTokenAirdrop(primary, otherAccounts);
});