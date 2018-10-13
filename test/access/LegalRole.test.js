
const {  shouldBehaveCpolloLikePublicRole } = require('./PublicRole.behavior');
const LegalRoleMock = artifacts.require('LegalRoleMock');
const CpolloRole = artifacts.require('CpolloRole');

contract('LegalRole', function ([_, cpollo , legal, otherLegal, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    this.cpolloContract.addCpollo(cpollo, { from: cpollo });
    this.contract = await LegalRoleMock.new(this.cpolloContract.address, { from: cpollo });
    await this.contract.addLegal(otherLegal, { from: cpollo });
    await this.contract.addLegal(legal, { from: cpollo });
  });

  shouldBehaveCpolloLikePublicRole(cpollo, legal, otherLegal, otherAccounts, 'legal');
});