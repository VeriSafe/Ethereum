pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame and we can adapt time
 */
contract TimedCrowdsale is Crowdsale, Ownable {
    using SafeMath for uint256;

    uint256 private openingTime;
    uint256 private closingTime;

    event TimesChanged(uint256 startTime, uint256 endTime, uint256 oldStartTime, uint256 oldEndTime);

    /**
    * @dev Reverts if not in crowdsale time range.
    */
    modifier onlyWhileOpen {
        // solium-disable-next-line security/no-block-members
        require(block.timestamp >= openingTime && block.timestamp <= closingTime);
        _;
    }

    /**
    * @dev Constructor, takes crowdsale opening and closing times.
    * @param _openingTime Crowdsale opening time
    * @param _closingTime Crowdsale closing time
    */
    constructor(uint256 _openingTime, uint256 _closingTime) public {
        // solium-disable-next-line security/no-block-members
        require(_openingTime >= block.timestamp);
        require(_closingTime >= _openingTime);

        openingTime = _openingTime;
        closingTime = _closingTime;
    }

    /**
    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
    * @return Whether crowdsale period has elapsed
    */
    function hasClosed() public view returns (bool) {
        // solium-disable-next-line security/no-block-members
        return block.timestamp > closingTime;
    }

    /**
    * @dev Extend parent behavior requiring to be within contributing period
    * @param _beneficiary Token purchaser
    * @param _weiAmount Amount of wei contributed
    */
    function _preValidatePurchase(
        address _beneficiary,
        uint256 _weiAmount
    )
        internal
        onlyWhileOpen
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
    }
    
    function setStartTime(uint256 _startTime) public onlyOwner {
        // only if CS was not started
        require(block.timestamp < openingTime);
        // only move time to future
        require(_startTime > openingTime);
        require(_startTime < closingTime);
        emit TimesChanged(_startTime, closingTime, openingTime, closingTime);
        openingTime = _startTime;
    }
    

    
    function setEndTime(uint256 _endTime) public onlyOwner {
        // only if CS was not ended
        require(block.timestamp < closingTime);
        // only if new end time in future
        require(block.timestamp < _endTime);
        require(_endTime > openingTime);
        emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
        closingTime = _endTime;
    }
    

    
    function setTimes(uint256 _startTime, uint256 _endTime) public onlyOwner {
        require(_endTime > _startTime);
        uint256 oldStartTime = openingTime;
        uint256 oldEndTime = closingTime;
        bool changed = false;
        if (_startTime != oldStartTime) {
            require(_startTime > block.timestamp);
            // only if CS was not started
            require(block.timestamp < oldStartTime);
            // only move time to future
            require(_startTime > oldStartTime);

            openingTime = _startTime;
            changed = true;
        }
        if (_endTime != oldEndTime) {
            // only if CS was not ended
            require(block.timestamp < oldEndTime);
            // end time in future
            require(block.timestamp < _endTime);

            closingTime = _endTime;
            changed = true;
        }

        if (changed) {
            emit TimesChanged(openingTime, _endTime, openingTime, closingTime);
        }
    }


}


