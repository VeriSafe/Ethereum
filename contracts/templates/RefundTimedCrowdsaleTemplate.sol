pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../crowdsale/VestedPostDeliveryCrowdsale.sol";

/**
* @title RefundTimedCrowdsaleTemplate,
 * @dev Template to be used to create RefundTimedCrowdsaleTemplate crowdsales with only post delivery
*
* 
 */
contract RefundTimedCrowdsaleTemplate is RefundableCrowdsale, CappedCrowdsale, PostDeliveryCrowdsale {

    constructor (
        uint256 rate,         // rate, in TKNbits
        address wallet,       // wallet to send Ether
        ERC20 token,          // the token
        uint256 cap,          // total cap, in wei
        uint256 openingTime,  // opening time in unix epoch seconds
        uint256 closingTime,   // closing time in unix epoch seconds
        uint256 goal   // closing time in unix epoch seconds
    )
    public
    Crowdsale(rate, wallet, token)
    CappedCrowdsale(cap)
    RefundableCrowdsale(goal)
    TimedCrowdsale(openingTime, closingTime)
    {
      require(goal <= cap, "cap must be higher than goal");
    }

}