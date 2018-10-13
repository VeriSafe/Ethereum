const PCO = artifacts.require('PCOMock');
const shouldFail = require('../helpers/shouldFail');
const { advanceBlock } = require('../helpers/advanceToBlock');
const BigNumber = web3.BigNumber;
const time = require('../helpers/time');
const ERC20Mock = artifacts.require('ERC20Mock');
const { ether } = require('../helpers/ether');

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();



contract('PCO', function ([_, investor, wallet, purchaser, owner]) {
    let vest = [];
    const cap =  [ether(100), ether(200), ether(300)];
    const rate = new BigNumber(1);

    const tokenSupply = ether(300);
    before(async function () {
        // Advance to the next block to correctly read time in the solidity "now" function interpreted by ganache
        await advanceBlock();
        });
  beforeEach(async function () {
    this.openingTime = (await time.latest()) + time.duration.weeks(1);
    this.closingTime = this.openingTime + time.duration.weeks(1);
    this.afterClosingTime = this.closingTime + time.duration.seconds(1);
    vest = [];
    vest.push(this.closingTime + time.duration.weeks(4));
    vest.push(this.closingTime + time.duration.weeks(8));
    vest.push(this.closingTime + time.duration.weeks(12));
   // console.log(vest.length);
    
    this.token = await ERC20Mock.new(owner, tokenSupply);
    
    this.crowdsale = await PCO.new(
                            vest,
                            cap,
                            vest.length,                 
                            this.openingTime, 
                            this.closingTime, 
                            rate, 
                            wallet, 
                            this.token.address,
                            {from: owner});
    
    
    await this.token.transfer(this.crowdsale.address, tokenSupply, {from: owner});
    
  });
  context('after opening time', function () {
    beforeEach(async function () {
      await time.increaseTo(this.openingTime + time.duration.seconds(60));
    });

    context('with bought tokens', function () {
      const value = ether(250);

      beforeEach(async function () {
        await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
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

        it('not allows beneficiaries to withdraw tokens before start vesting 1', async function () {
            (await this.crowdsale.withdrawWillFail(investor, value)).should.be.equal(false);
            
            await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
    
        });


      });
      context('after vesting 1', function () {
        beforeEach(async function () {
          await time.increaseTo(vest[0] + time.duration.seconds(1));
        });

        it('not allows beneficiaries to withdraw tokens higher cap 1', async function () {
            (await this.crowdsale.withdrawWillFail(investor, value)).should.be.equal(false);
        
            await shouldFail.reverting(this.crowdsale.withdrawTokens(investor));
    
        });

      });
      context('after vesting 2', function () {
        beforeEach(async function () {
          await time.increaseTo(vest[1] + time.duration.seconds(1));
        });

        it('not allows beneficiaries to withdraw tokens higher than cap 2', async function () {
            (await this.crowdsale.withdrawWillFail(investor, value)).should.be.equal(false);
             
        });

      });
      context('after vesting 3', function () {
        beforeEach(async function () {
          await time.increaseTo(vest[2] + time.duration.seconds(60));
        });

        it('allows beneficiaries to withdraw tokens after vesting 3', async function () {
            (await this.crowdsale.withdrawWillFail(investor, value)).should.be.equal(true);
          
            await this.crowdsale.withdrawTokens(investor);
          
            (await this.crowdsale.balanceOf(investor)).should.be.bignumber.equal(0);
            (await this.token.balanceOf(investor)).should.be.bignumber.equal(value);
          });

      });


    });
  });
  
  
});