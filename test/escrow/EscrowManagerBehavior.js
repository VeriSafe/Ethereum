const { ZERO_ADDRESS } = require('../helpers/constants');
const shouldFail = require('../helpers/shouldFail');
const expectEvent = require('../helpers/expectEvent');
const { ether } = require('../helpers/ether');
const BigNumber = web3.BigNumber;
require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeManagerEscrow (dev, notDev, escrowManager, notEscrowManager, amountLimit) {  
    describe('Escrow Dev Transfers', function () {
        context('from authorized account', function () {
        

        it('allows transfer to developer', async function () {
            const amount = ether(amountLimit - 10);
            await this.contract.transfer(dev, amount, { from: escrowManager });
        });
        it('Pull correct amount transfered to developer', async function () {
            const amount = ether(amountLimit/3);
            await this.contract.transfer(dev, amount, { from: escrowManager });
            await this.contract.transfer(dev, amount, { from: escrowManager });
            (await this.contract.transfersOf(dev)).should.be.bignumber.equal(amount.plus(amount));
        });
        it('Not allows transfer over the Limit', async function () {
            const amount = ether(amountLimit + 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from:escrowManager }));
        });

        it('Not allows transfer to non developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from:escrowManager }));
        });
        it('reverts when transfer  to the null account', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(ZERO_ADDRESS, amount, { from: escrowManager }));
            });
        it('reverts when transfer  null value with null account', async function () {
            const amount = ether(0);
            await shouldFail.reverting(this.contract.transfer(ZERO_ADDRESS, amount, { from: escrowManager }));
            });

        it('reverts when transfer  null value to developer', async function () {
            const amount = ether(0);
            await shouldFail.reverting(this.contract.transfer(dev, amount, { from: escrowManager }));
            });
            
        
        });

        context('from unauthorized account', function () {
        it('reverts when tries to transfer to developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(dev, amount, { from:notEscrowManager }));
        });
        it('reverts  when tries to transfer to  not developer', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from:notEscrowManager }));
        });
        it('reverts when tries to transfer to  not developer over the limit', async function () {
            const amount = ether(amountLimit - 1);
            await shouldFail.reverting(this.contract.transfer(notDev, amount, { from:notEscrowManager }));
        });
        });

    });
}


module.exports = {
    shouldBehaveLikeManagerEscrow
  };