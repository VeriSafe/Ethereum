pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../crowdsale/VestedPostDeliveryCrowdsale.sol";




contract PCOTemplate is VestedPostDeliveryCrowdsale {

    constructor (
        uint256[] vestingTime,
        uint256[] capsToken,
        uint256 length,
        uint256 openingTime,
        uint256 closingTime,
        uint256 rate,
        address wallet,
        IERC20 token
    )
    public
    VestedPostDeliveryCrowdsale(vestingTime, capsToken, length)
    TimedCrowdsale(openingTime, closingTime)
    Crowdsale(rate, wallet, token)
    {
    }

}