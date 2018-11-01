const shouldFail = require('../../../helpers/shouldFail');
const expectEvent = require('../../../helpers/expectEvent');
const time = require('../../../helpers/time');
const { ZERO_ADDRESS } = require('../../../helpers/constants');
const { ether } = require('../../../helpers/ether');
const { ethGetBalance } = require('../../../helpers/web3');
const BigNumber = web3.BigNumber;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

function shouldBehaveLikeFinalizableCrowdsale(anyone) {
    context('With Finalizable crowdsale', function () {
        it('cannot be finalized before ending', async function () {
            await shouldFail.reverting(this.crowdsale.finalize({ from: anyone }));
          });
        
          it('can be finalized by anyone after ending', async function () {
            await time.increaseTo(this.afterClosingTime);
            await this.crowdsale.finalize({ from: anyone });
          });
        
          it('cannot be finalized twice', async function () {
            await time.increaseTo(this.afterClosingTime);
            await this.crowdsale.finalize({ from: anyone });
            await shouldFail.reverting(this.crowdsale.finalize({ from: anyone }));
          });
        
          it('logs finalized', async function () {
            await time.increaseTo(this.afterClosingTime);
            const { logs } = await this.crowdsale.finalize({ from: anyone });
            expectEvent.inLogs(logs, 'CrowdsaleFinalized');
          });
             
      });
}

module.exports = {
    shouldBehaveLikeFinalizableCrowdsale,
};
