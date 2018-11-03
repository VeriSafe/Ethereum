const expectEvent = require('../helpers/expectEvent');
const shouldFail = require('../helpers/shouldFail');
const { ethGetBalance } = require('../helpers/web3');
const { ether } = require('../helpers/ether');

const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeAirdrop (primary, [payee1, payee2]) {
  const amount = ether(42.0);

  describe('as an airdrop', function () {
    describe('deposits', function () {
      it('deposit tokens', async function () {
        await this.escrow.deposit(payee1, amount, { from: primary});


        (await this.escrow.depositsOf(payee1)).should.be.bignumber.equal(amount);
      });

      it('can accept an empty deposit', async function () {
        await this.escrow.deposit(payee1, 0 , { from: primary });
      });

      it('only the primary account can deposit', async function () {
        await shouldFail.reverting(this.escrow.deposit(payee1, amount, { from: payee2 }));
      });

      it('emits a deposited event', async function () {
        const { logs } = await this.escrow.deposit(payee1, amount, { from: primary });
        expectEvent.inLogs(logs, 'Deposited', {
          payee: payee1,
          amount: amount,
        });
      });

      it('can add multiple deposits on a single account', async function () {
        await this.escrow.deposit(payee1, amount,  { from: primary, });
        await this.escrow.deposit(payee1,  amount * 2, { from: primary });

        (await this.escrow.depositsOf(payee1)).should.be.bignumber.equal(amount * 3);
      });

      it('can track deposits to multiple accounts', async function () {
        await this.escrow.deposit(payee1, amount, { from: primary });
        await this.escrow.deposit(payee2, amount * 2, { from: primary  });

        (await this.escrow.depositsOf(payee1)).should.be.bignumber.equal(amount);

        (await this.escrow.depositsOf(payee2)).should.be.bignumber.equal(amount * 2);
      });
    });

    describe('withdrawals', async function () {
      it('can withdraw payments', async function () {
        const payeeInitialBalance = await ethGetBalance(payee1);

        await this.escrow.deposit(payee1, amount, { from: primary});
        await this.escrow.withdraw(payee1, { from: primary });

        
        (await this.escrow.depositsOf(payee1)).should.be.bignumber.equal(0);

       
      });

      it('can do an empty withdrawal', async function () {
        await this.escrow.withdraw(payee1, { from: primary });
      });

      it('Other  accounts can withdraw', async function () {
        await this.escrow.withdraw(payee1, { from: payee1 });
      });

      it('emits a withdrawn event', async function () {
        await this.escrow.deposit(payee1, amount, { from: primary });
        const { logs } = await this.escrow.withdraw(payee1, { from: primary });
        expectEvent.inLogs(logs, 'Withdrawn', {
          payee: payee1,
          amount: amount,
        });
      });
    });
  });
}

module.exports = {
  shouldBehaveLikeAirdrop,
};
