pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../crowdsale/validation/TimedCrowdsale.sol";

/**
* @title RefundTimedCrowdsaleTemplate,
 * @dev Template to be used to create RefundTimedCrowdsaleTemplate crowdsales with only post delivery
*
* 
 */
contract TimedChangeCrowdsaledMock is TimedCrowdsale {

    constructor (
        uint256 openingTime,  // opening time in unix epoch seconds
        uint256 closingTime,   // closing time in unix epoch seconds
        uint256 rate,         // rate, in TKNbits
        address wallet,       // wallet to send Ether
        IERC20 token        // the token
    )
    public
    TimedCrowdsale(openingTime, closingTime)
    Crowdsale(rate, wallet, token)
    {
       
    }

}