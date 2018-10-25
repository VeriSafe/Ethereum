
const { shouldBehaveLikePublicRole } = require('./PublicRole.behavior');
const CpolloRoleMock = artifacts.require('CpolloRoleMock');

contract('CpolloRoleMock', function ([_, cpollo, otherCpollo, ...otherAccounts]) {
  beforeEach(async function () {
 
    this.contract = await CpolloRoleMock.new({ from: cpollo });
    await this.contract.addCpollo(otherCpollo, { from: cpollo});
  });

  shouldBehaveLikePublicRole(cpollo, otherCpollo, otherAccounts, 'cpollo');
});