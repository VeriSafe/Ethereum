
const {  shouldBehaveCpolloLikePublicRole } = require('./PublicRole.behavior');
const MarketingRoleMock = artifacts.require('MarketingRoleMock');
const CpolloRole = artifacts.require('CpolloRole');

contract('MarketingRole', function ([_, cpollo , marketeer, otherMarketeer, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    this.cpolloContract.addCpollo(cpollo, { from: cpollo });
    this.contract = await MarketingRoleMock.new(this.cpolloContract.address, { from: cpollo });
    await this.contract.addMarketing(otherMarketeer, { from: cpollo });
    await this.contract.addMarketing(marketeer, { from: cpollo });
  });

  shouldBehaveCpolloLikePublicRole(cpollo, marketeer, otherMarketeer, otherAccounts, 'marketing');
});