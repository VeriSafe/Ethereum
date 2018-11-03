const { shouldBehaveLikeKYCAirdrop } = require('./behaviors/KYCAirdrop.behavior');
const UserRoleMock = artifacts.require('UserRoleMock');
const CpolloRole = artifacts.require('CpolloRole');
const Airdrop = artifacts.require('KYCAirdrop');

contract('KYC Airdrop', function ([_, primary, cpollo, nonKYC, KYC1, KYC2, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    this.cpolloContract.addCpollo(cpollo, { from: cpollo });
    this.contract = await UserRoleMock.new(this.cpolloContract.address, { from: cpollo });
    this.airdrop = await Airdrop.new(this.contract.address, { from: primary });
   
    await this.contract.addUser(KYC1, { from: cpollo });
    await this.contract.addUser(KYC2, { from: cpollo });
  });

  shouldBehaveLikeKYCAirdrop(primary, [KYC1, KYC2 ], nonKYC);
});