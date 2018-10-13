
const {  shouldBehaveCpolloLikePublicRole } = require('./PublicRole.behavior');
const DevRoleMock = artifacts.require('DevRoleMock');
const CpolloRole = artifacts.require('CpolloRole');

contract('DevRole', function ([_, cpollo , dev, otherDev, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    this.cpolloContract.addCpollo(cpollo, { from: cpollo });
    this.contract = await DevRoleMock.new(this.cpolloContract.address, { from: cpollo });
    await this.contract.addDev(otherDev, { from: cpollo });
    await this.contract.addDev(dev, { from: cpollo });
  });

  shouldBehaveCpolloLikePublicRole(cpollo, dev, otherDev, otherAccounts, 'dev');
});