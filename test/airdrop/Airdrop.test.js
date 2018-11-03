const { shouldBehaveLikeAirdrop } = require('./behaviors/Airdrop.behavior');

const Airdrop = artifacts.require('Airdrop');

contract('Airdrop', function ([_, primary, ...otherAccounts]) {
  beforeEach(async function () {
    this.airdrop = await Airdrop.new({ from: primary });
  });

  shouldBehaveLikeAirdrop(primary, otherAccounts);
});