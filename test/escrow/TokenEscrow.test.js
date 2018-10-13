const TokenEscrowMock = artifacts.require('TokenEscrowMock');
const shouldFail = require('../helpers/shouldFail');
const CpolloRole = artifacts.require('CpolloRole');
const ERC20Mock = artifacts.require('ERC20Mock');
const BigNumber = web3.BigNumber;
const { ether } = require('../helpers/ether');
const expectEvent = require('../helpers/expectEvent');
const {  shouldBehaveLikeCpolloEscrow } = require('./CpolloBehavior');


require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();
  
const tokenSupply = ether(20000000000);

contract('TokenEscrow', function ([_, cpollo , dev, notDev, owner, teamWallet, escrowManager, notEscrowManager, ...otherAccounts]) {
  beforeEach(async function () {
    this.cpolloContract = await CpolloRole.new({ from: cpollo });
    
    this.token = await ERC20Mock.new(owner, tokenSupply);
    

    this.contract = await TokenEscrowMock.new(
                            teamWallet,
                            this.cpolloContract.address,  
                            this.token.address,                                                  
                            { from: cpollo });

    await this.token.transfer(this.contract.address, tokenSupply, { from: owner });
  });

  shouldBehaveLikeCpolloEscrow (cpollo, teamWallet, tokenSupply);

  describe('Escrow Transfers', function () {
    context('from authorized account', function () {
      it('allows transfer', async function () {
        const amount = ether(1);
        await this.contract.transfer(dev, amount, { cpollo });
      });    
    });
  });
  
});