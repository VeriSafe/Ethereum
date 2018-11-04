pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../token-crowdsale/validation/TokenTimedCrowdsale.sol";
import "../token-crowdsale/validation/TokenCappedCrowdsale.sol";
import "../token-crowdsale/distribution/TokenPostDeliveryCrowdsale.sol";
import "../token-crowdsale/distribution/TokenRefundableCrowdsale.sol";

/**
* @title RefundTimedTokenCrowdsaleTemplate,
 * @dev Template to be used to create RefundTimedTokenCrowdsaleTemplate crowdsales with only post delivery
*
* 
 */
contract RefundTimedTokenCrowdsaleTemplate is  TokenCappedCrowdsale, TokenRefundableCrowdsale, TokenPostDeliveryCrowdsale {

    constructor (
        uint256 openingTime,  // opening time in unix epoch seconds
        uint256 closingTime,   // closing time in unix epoch seconds
        uint256 rate,         // rate, in TKNbits
        address wallet,       // wallet to send Ether
        IERC20 token,          // the token
        IERC20 exchangeToken,          // the token
        uint256 goal,   // Minimum goal to reach
        uint256 cap          // total cap, in wei
    )
    public
    TokenCrowdsale(rate, wallet, token, exchangeToken)
    TokenTimedCrowdsale(openingTime, closingTime)  
    TokenCappedCrowdsale(cap)
    TokenRefundableCrowdsale(goal)
    {
        require(goal <= cap, "cap must be higher than goal");
    }

}