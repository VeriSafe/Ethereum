pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../crowdsale/validation/TimedCrowdsale.sol";
import "../crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "../crowdsale/distribution/RefundableCrowdsale.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";


/**
* @title RefundTimedChangeCrowdsaleTemplate,
* @dev Template to be used to create RefundTimedChangeCrowdsaleTemplate crowdsales with only post delivery
*
* 
*/
contract RefundTimedChangeCrowdsaleTemplate is RefundableCrowdsale, CappedCrowdsale, PostDeliveryCrowdsale {

    constructor (
        uint256 openingTime,  // opening time in unix epoch seconds
        uint256 closingTime,   // closing time in unix epoch seconds
        uint256 rate,         // rate, in TKNbits
        address wallet,       // wallet to send Ether
        ERC20 token,          // the token
        uint256 cap,          // total cap, in wei
        uint256 goal   // closing time in unix epoch seconds
    )
    public
    RefundableCrowdsale(goal)
    CappedCrowdsale(cap)
    TimedCrowdsale(openingTime, closingTime)
    Ownable()
    Crowdsale(rate, wallet, token)
    {
        require(goal <= cap, "cap must be higher than goal");
    }

}
