const expectEvent = require('../../helpers/expectEvent');
const shouldFail = require('../../helpers/shouldFail');
const { ethGetBalance } = require('../../helpers/web3');
const { ether } = require('../../helpers/ether');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeKYCAirdrop (primary, [payee1, payee2], nonKYC) {
  const amount = ether(42.0);

  describe('as an airdrop', function () {
    describe('deposits', function () {
      
      it('deposit tokens in KYC user', async function () {
        await this.airdrop.deposit(payee1, amount, { from: primary});


        (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount);
      });
      it('can not deposit tokens in non KYC user', async function () {
        await shouldFail.reverting(this.airdrop.deposit(nonKYC, amount, { from: primary}));

      });

      it('cannot  accept an empty deposit', async function () {
        await shouldFail.reverting(this.airdrop.deposit(payee1, 0 , { from: primary }));
      });

      it('only the primary account can deposit', async function () {
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
        await this.airdrop.deposit(payee1, amount,  { from: primary, });
        await this.airdrop.deposit(payee1,  amount * 2, { from: primary });

        (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount * 3);
      });

      it('can track deposits to multiple accounts', async function () {
        await this.airdrop.deposit(payee1, amount, { from: primary });
        await this.airdrop.deposit(payee2, amount * 2, { from: primary  });

        (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(amount);

        (await this.airdrop.depositsOf(payee2)).should.be.bignumber.equal(amount * 2);
      });
    });

    describe('withdrawals', async function () {
      it('can withdraw payments', async function () {

        await this.airdrop.deposit(payee1, amount, { from: primary});
        await this.airdrop.withdraw({ from: payee1 });      
        (await this.airdrop.depositsOf(payee1)).should.be.bignumber.equal(0);

       
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
  });
}

module.exports = {
  shouldBehaveLikeKYCAirdrop,
};
