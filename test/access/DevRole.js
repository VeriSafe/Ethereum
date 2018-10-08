
const { shouldBehaveLikePublicRole } = require('./PublicRole.behavior');
const DevRoleMock = artifacts.require('DevRoleMock');
const CpolloRoleMock = artifacts.require('CpolloRoleMock');

contract('DevRole', function ([_, cpollo , dev, otherDev, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRoleMock.new({ from: cpollo });
    this.contract = await DevRoleMock.new([this.cpolloContract.address],{ from: dev });
    await this.contract.addDev(otherDev, { from: dev });
  });

  shouldBehaveLikePublicRole(dev, otherDev, otherAccounts, 'dev');
});