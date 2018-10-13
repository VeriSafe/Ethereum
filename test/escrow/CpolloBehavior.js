
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const BigNumber = web3.BigNumber;
require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();


function shouldBehaveLikeCpolloEscrow (cpollo, teamWallet, tokenSupply) {  
    describe('Cpollo Escrow Behavior', function () {
        context('Cpollo features', function () {
            it('should be active', async function () {     
                const state = new BigNumber(0);
              (await this.contract.state({ from: cpollo })).should.be.bignumber.equal(state);
            });
            it('should be in freeze', async function () {     
                await this.contract.freeze({ from: cpollo }); 
                const state = new BigNumber(1);
                (await this.contract.state({ from: cpollo })).should.be.bignumber.equal(state);
              });
            it('Emits Freeze Event', async function () {     
                const { logs } = await this.contract.freeze({ from: cpollo });  
                expectEvent.inLogs(logs, 'FreezeAlert', { account: cpollo });
            });
            it('Emits unFreeze Event', async function () {
                await this.contract.freeze({ from: cpollo });       
                const { logs } = await this.contract.unFreeze({ from: cpollo });  
                expectEvent.inLogs(logs, 'unFreezeAlert', { account: cpollo });
            });
            it('Cannot call unFreeze when active', async function () {     
                 await shouldFail.reverting(this.contract.unFreeze({ from: cpollo }));
            });
            it('should be in scam', async function () {     
                await this.contract.scamAlert({ from: cpollo });  
                const state = new BigNumber(2);
                (await this.contract.state({ from: cpollo })).should.be.bignumber.equal(state);
            });
            it('Emits Scam alert Event', async function () {     
                const { logs } = await this.contract.scamAlert({from: cpollo });  
                expectEvent.inLogs(logs, 'ScamAlert', { account: cpollo });
             
            });
         
    
            it('returns refund wallet', async function () {        
              (await this.contract.refundWallet({ from: cpollo })).should.equal(teamWallet);
            });
            
          });
    
      });
  }

  module.exports = {
    shouldBehaveLikeCpolloEscrow
  };