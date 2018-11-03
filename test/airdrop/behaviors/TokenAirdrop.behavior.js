const expectEvent = require('../../helpers/expectEvent');
const shouldFail = require('../../helpers/shouldFail');
const { ethGetBalance } = require('../../helpers/web3');
const { ether } = require('../../helpers/ether');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeTokenAirdrop (primary, [payee1, payee2]) {
  const amount = ether(42.0);

  describe('as an airdrop', function () {
    describe('deposits', function () {    
        context('when tokens are in Airdrop', function () {
            beforeEach(async function () {
                await this.token.transfer(this.airdrop.address, amount, {from: primary});
            });
            it('deposit tokens', async function () {
                
                await this.airdrop.deposit(payee1, amount, { from: primary});
                (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount);
                
            });

            it('cannot  accept an empty deposit', async function () {
                await shouldFail.reverting(this.airdrop.deposit(payee1, 0 , { from: primary }));
            });

            it('only the primary account can deposit', async function () {
                await this.token.transfer(payee1, amount, {from: primary});
                await shouldFail.reverting(this.airdrop.deposit(payee1, amount, { from: payee2 }));
            });

            it('emits a deposited event', async function () {
                const { logs } = await this.airdrop.deposit(payee1, amount, { from: primary });
                expectEvent.inLogs(logs, 'Deposited', {
                payee: payee1,
                amount: amount,
                });
            });

            it('can add multiple deposits on a single account', async function () {
                await this.token.transfer(payee1, amount * 2, {from: primary});
                await this.airdrop.deposit(payee1, amount,  { from: primary, });
                await this.airdrop.deposit(payee1,  amount * 2, { from: primary });

                (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount * 3);
            });

            it('can track deposits to multiple accounts', async function () {
                await this.token.transfer(payee1, amount * 2, {from: primary});
                await this.airdrop.deposit(payee1, amount, { from: primary });
                await this.airdrop.deposit(payee2, amount * 2, { from: primary  });

                (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount);

                (await this.airdrop.depositsOf(payee2)).should.be.bignumber.equal(amount * 2);
            });
        });
      
    });

    describe('withdrawals', async function () {
      context('when tokens are in Airdrop', function () {
        beforeEach(async function () {
            await this.token.transfer(this.airdrop.address, amount, {from: primary});
          });
        it('airdrop have correct funds', async function () {
     
            (await this.token.balanceOf(this.airdrop.address)).should.be.bignumber.equal(amount);   
          
        });
        it('airdrop returns corrects values', async function () {
            await this.airdrop.deposit(payee1, amount, { from: primary});
            (await this.airdrop.totalDeposits()).should.be.bignumber.equal(amount);  
            await this.airdrop.withdraw({ from: payee1 });
            (await this.airdrop.totalAirdrops()).should.be.bignumber.equal(amount);  

          
        });
        it('can withdraw payments', async function () {

            await this.airdrop.deposit(payee1, amount, { from: primary});
            await this.airdrop.withdraw({ from: payee1 });
            
            
            (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(0);
           (await this.token.balanceOf(payee1)).should.be.bignumber.equal(amount);      
        });

        it('cannot  do an empty withdrawal', async function () {
            await shouldFail.reverting(this.airdrop.withdraw({ from: payee1 }));
        });

        it('emits a withdrawn event', async function () {
            await this.airdrop.deposit(payee1, amount, { from: primary });
            const { logs } = await this.airdrop.withdraw( { from: payee1 });
            expectEvent.inLogs(logs, 'Withdrawn', {
            payee: payee1,
            amount: amount,
            });
        });
      });
      context('when tokens are not in Airdrop', function () {
        it('can not withdraw tokens that not are in balance', async function () { 
            await this.airdrop.deposit(payee1, amount, { from: primary});
            (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount);
            await shouldFail.reverting(this.airdrop.withdraw({ from: payee1 }));    
        });

        it('cannot  accept an empty deposit', async function () {
            await shouldFail.reverting(this.airdrop.deposit(payee1, 0 , { from: primary }));
        });

        });
     });



    });
}

module.exports = {
    shouldBehaveLikeTokenAirdrop,
};
