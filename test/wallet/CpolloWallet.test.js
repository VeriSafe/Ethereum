
const shouldFail = require('../helpers/shouldFail');
const CpolloRole = artifacts.require('CpolloRole');
const CpolloWallet = artifacts.require('CpolloWalletMock');
const BigNumber = web3.BigNumber;


require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

contract('Cpollo Wallet', function ([_, cpollo , dev, notDev, owner, teamWallet, escrowManager, notWalletManager, ...otherAccounts]) {
  beforeEach( async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    

    this.contract = await CpolloWallet.new(
                            teamWallet,
                            this.cpolloContract.address,                                         
                            { from: cpollo });
    
                            
  });

  describe('Cpollo Wallet features', function () {
    context('constants', function () {
        it('should be active', async function () {
          await this.contract.state({ cpollo });
        });
        it('returns refund wallet', async function () {
          await this.contract.refundWallet({ cpollo }).should.equal(teamWallet);
        });
      });

  });
  
});