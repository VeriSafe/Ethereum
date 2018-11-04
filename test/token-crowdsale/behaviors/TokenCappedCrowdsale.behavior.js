const shouldFail = require('../../helpers/shouldFail');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeTokenCappedCrowdsale(investor, cap, lessThanCap) {
    context('With Token Capped crowdsale', function () {
        beforeEach(async function () {
          await this.tokenExchange.approve(this.crowdsale.address, 2*cap, {from: investor});
        });
        describe('accepting payments', function () {
          it('should accept payments within cap', async function () {
            await this.crowdsale.buyTokens(investor, cap.minus(lessThanCap));
          });
    
          it('should reject payments outside cap', async function () {
            await this.crowdsale.buyTokens(investor, cap);
            await shouldFail.reverting(this.crowdsale.buyTokens(investor, 1));
          });
    
          it('should reject payments that exceed cap', async function () {
            await shouldFail.reverting(this.crowdsale.buyTokens(investor, cap.plus(1)));
          });
        });
    
        describe('ending', function () {
          it('should not reach cap if sent under cap', async function () {
            await this.crowdsale.buyTokens(investor, lessThanCap);
            (await this.crowdsale.capReached()).should.equal(false);
          });
    
          it('should not reach cap if sent just under cap', async function () {
            await this.crowdsale.buyTokens(investor, cap.minus(1));
            (await this.crowdsale.capReached()).should.equal(false);
          });
    
          it('should reach cap if cap sent', async function () {
            await this.crowdsale.buyTokens(investor, cap);
            (await this.crowdsale.capReached()).should.equal(true);
          });
        });
      });
}

module.exports = {
    shouldBehaveLikeTokenCappedCrowdsale,
};
