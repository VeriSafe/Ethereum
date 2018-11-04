pragma solidity ^0.4.24;

import "../TokenCrowdsale.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";
/**
 * @title TokenDynamicPriceCrowdsale
 * @dev Extension of Crowdsale contract that allows crowdsales to dynamically set the price in tokens. This can be used
 * to create OTC crowdsales
 */
contract TokenDynamicPriceCrowdsale is TokenCrowdsale, Secondary {
    using SafeMath for uint256;

    uint256 private _rate;

    event priceChanged(address who, uint256 previousRate, uint256 newRate, uint256 timestamp);

    /**
    * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
    * @param rate Number of tokens a buyer gets per tokens at the start of the crowdsale
    */
    constructor(uint256 rate) public {
        require(rate > 0);

        _rate = rate;
    }

    /**
    * @return the rate of the crowdsale.
    */
    function rate() public view returns(uint256) {
        return _rate;
    }

    /**
    * @return the final rate of the crowdsale.
    */
    function setRate(uint256 newRate) public onlyPrimary {
        require(newRate > 0);
        uint256 oldRate = _rate;
        _rate = newRate;
        emit priceChanged(msg.sender, oldRate, newRate, block.timestamp);
    }

   /**
    * @dev Override to extend the way in which ether is converted to tokens.
    * @param amount Value in tokens to be converted into tokens
    * @return Number of tokens that can be purchased with the specified _weiAmount
    */
    function _getTokenAmount(uint256 amount)
      internal view returns (uint256)
    {
        return amount.mul(_rate);
    }

}
