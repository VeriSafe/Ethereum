const {  shouldBehaveCpolloLikePublicRole } = require('./PublicRole.behavior');
const UserRole = artifacts.require('UserRole');
const CpolloRole = artifacts.require('CpolloRole');

contract('UserRole', function ([_, cpollo , user, otherUser, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    this.cpolloContract.addCpollo(cpollo, { from: cpollo });
    this.contract = await UserRole.new(this.cpolloContract.address, { from: cpollo });
    await this.contract.addUser(otherUser, { from: cpollo });
    await this.contract.addUser(user, { from: cpollo });
  });

  shouldBehaveCpolloLikePublicRole(cpollo, user, otherUser, otherAccounts, 'user');
});