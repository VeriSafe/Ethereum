pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "../crowdsale/VestedPostDeliveryCrowdsale.sol";

/**
* @title RefundTimedChangeCrowdsaleTemplate,
* @dev Template to be used to create RefundTimedChangeCrowdsaleTemplate crowdsales with only post delivery
*
* 
*/
contract RefundTimedChangeCrowdsaleTemplate2 is RefundableCrowdsale, CappedCrowdsale, PostDeliveryCrowdsale {
    event TimesChanged(uint startTime, uint endTime, uint oldStartTime, uint oldEndTime);
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
     function setStartTime(uint _startTime) public onlyOwner {
        // only if CS was not started
        require(now < openingTime);
        // only move time to future
        require(_startTime > openingTime);
        require(_startTime < closingTime);
        emit TimesChanged(_startTime, closingTime, openingTime, closingTime);
        openingTime = _startTime;
    }
    

    
    function setEndTime(uint _endTime) public onlyOwner {
        // only if CS was not ended
        require(now < closingTime);
        // only if new end time in future
        require(now < _endTime);
        require(_endTime > openingTime);
        emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
        closingTime = _endTime;
    }
    

    
    function setTimes(uint _startTime, uint _endTime) public onlyOwner {
        require(_endTime > _startTime);
        uint oldStartTime = openingTime;
        uint oldEndTime = closingTime;
        bool changed = false;
        if (_startTime != oldStartTime) {
            require(_startTime > now);
            // only if CS was not started
            require(now < oldStartTime);
            // only move time to future
            require(_startTime > oldStartTime);

            openingTime = _startTime;
            changed = true;
        }
        if (_endTime != oldEndTime) {
            // only if CS was not ended
            require(now < oldEndTime);
            // end time in future
            require(now < _endTime);

            closingTime = _endTime;
            changed = true;
        }

        if (changed) {
            emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
        }

}