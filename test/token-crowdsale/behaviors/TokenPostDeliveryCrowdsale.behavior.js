const shouldFail = require('../../helpers/shouldFail');
const expectEvent = require('../../helpers/expectEvent');
const { ZERO_ADDRESS } = require('../../helpers/constants');
const { advanceBlock } = require('../../helpers/advanceToBlock');
const time = require('../../helpers/time');
const { ether } = require('../../helpers/ether');
const { ethGetBalance } = require('../../helpers/web3');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeTokenPostDeliveryCrowdsale(investor, purchaser, tokenSupply, value) {
    context('with Token PostDelivery crowdsale', function () {
         context('after opening time', function () {
            beforeEach(async function () {
            await time.increaseTo(this.openingTime);
            });

            context('with bought tokens', function () {
            
                beforeEach(async function () {
                    await this.tokenExchange.approve(this.crowdsale.address, value, {from: investor});
                    await this.crowdsale.buyTokens(investor, value, {from: investor });
                });

                it('does not immediately assign tokens to beneficiaries', async function () {
                    (await this.crowdsale.balanceOf(investor)).should.be.bignumber.equal(value);
                    (await this.token.balanceOf(investor)).should.be.bignumber.equal(0);
                });

                it('does not allow beneficiaries to withdraw tokens before crowdsale ends', async function () {
                    await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
                });

                context('after closing time', function () {
                    beforeEach(async function () {
                        await time.increaseTo(this.afterClosingTime);
                    });

                    it('allows beneficiaries to withdraw tokens', async function () {
                        await this.crowdsale.withdrawTokens(investor);
                        (await this.crowdsale.balanceOf(investor)).should.be.bignumber.equal(0);
                        (await this.token.balanceOf(investor)).should.be.bignumber.equal(value);
                    });

                    it('rejects multiple withdrawals', async function () {
                        await this.crowdsale.withdrawTokens(investor);
                        await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
                    });
                });
            });
        });
    });
}

module.exports = {
    shouldBehaveLikeTokenPostDeliveryCrowdsale
};
