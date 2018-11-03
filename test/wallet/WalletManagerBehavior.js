const { ZERO_ADDRESS } = require('../helpers/constants');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const { ether } = require('../helpers/ether');
const BigNumber = web3.BigNumber;
require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeManagerWallet (dev, notDev, walletManager, notWalletManager, amountLimit) {  
    describe('Wallet Dev Transfers', function () {
        context('from authorized account', function () {
        

        it('allows transfer to developer', async function () {
            const amount = ether(amountLimit - 10);
            await this.contract.transfer(dev, amount, { from: walletManager });
        });
        it('Pull correct amount transfered to developer', async function () {
            const amount = ether(amountLimit/3);
            await this.contract.transfer(dev, amount, { from: walletManager });
            await this.contract.transfer(dev, amount, { from: walletManager });
            (await this.contract.transfersOf(dev)).should.be.bignumber.equal(amount.plus(amount));
        });
        it('Not allows transfer over the Limit', async function () {
            const amount = ether(amountLimit + 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from: walletManager }));
        });

        it('Not allows transfer to non developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from: walletManager }));
        });
        it('reverts when transfer  to the null account', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(ZERO_ADDRESS, amount, { from: walletManager }));
            });
        it('reverts when transfer  null value with null account', async function () {
            const amount = ether(0);
            await shouldFail.reverting(this.contract.transfer(ZERO_ADDRESS, amount, { from: walletManager }));
            });

        it('reverts when transfer  null value to developer', async function () {
            const amount = ether(0);
            await shouldFail.reverting(this.contract.transfer(dev, amount, { from: walletManager }));
            });
            
        
        });

        context('from unauthorized account', function () {
        it('reverts when tries to transfer to developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(dev, amount, { from: notWalletManager }));
        });
        it('reverts  when tries to transfer to  not developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from: notWalletManager }));
        });
        it('reverts when tries to transfer to  not developer over the limit', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from: notWalletManager }));
        });
        });

    });
}


module.exports = {
    shouldBehaveLikeManagerWallet
  };