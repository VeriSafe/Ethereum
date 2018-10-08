
const { shouldBehaveLikePublicRole } = require('./PublicRole.behavior');
const CpolloRoleMock = artifacts.require('CpolloRoleMock');

contract('DevRole', function ([_, dev, otherDev, ...otherAccounts]) {
  beforeEach(async function () {
    this.contract = await DevRoleMock.new({ from: dev });
    await this.contract.addDev(otherDev, { from: dev });
  });

  shouldBehaveLikePublicRole(dev, otherDev, otherAccounts, 'dev');
});