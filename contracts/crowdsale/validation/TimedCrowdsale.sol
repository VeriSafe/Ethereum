pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame and we can adapt time
 */
contract TimedCrowdsale is Crowdsale, Ownable {
    using SafeMath for uint256;

    uint256 private _openingTime;
    uint256 private _closingTime;

    event TimesChanged(uint256 startTime, uint256 endTime, uint256 oldStartTime, uint256 oldEndTime);

    /**
    * @dev Reverts if not in crowdsale time range.
    */
    modifier onlyWhileOpen {
        // solium-disable-next-line security/no-block-members
        require(block.timestamp >= _openingTime && block.timestamp <= _closingTime);
        _;
    }

    /**
    * @dev Constructor, takes crowdsale opening and closing times.
    * @param openingTime Crowdsale opening time
    * @param closingTime Crowdsale closing time
    */
    constructor(uint256 openingTime, uint256 closingTime) public {
        // solium-disable-next-line security/no-block-members
        require(openingTime >= block.timestamp);
        require(closingTime >= openingTime);

        _openingTime = openingTime;
        _closingTime = closingTime;
    }
    /**
    * @return the crowdsale opening time.
    */
    function openingTime() public view returns(uint256) {
        return _openingTime;
    }

    /**
    * @return the crowdsale closing time.
    */
    function closingTime() public view returns(uint256) {
        return _closingTime;
    }

    /**
    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
    * @return Whether crowdsale period has elapsed
    */
    function hasClosed() public view returns (bool) {
        // solium-disable-next-line security/no-block-members
        return block.timestamp > _closingTime;
    }
    /**
    * @return true if the crowdsale is open, false otherwise.
    */
    function isOpen() public view returns (bool) {
        // solium-disable-next-line security/no-block-members
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
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
    
    function setStartTime(uint256 startTime) public onlyOwner {
        // only if CS was not started
        require(block.timestamp < _openingTime);
        // only move time to future
        require(startTime > _openingTime);
        require(startTime < _closingTime);
        emit TimesChanged(startTime, _closingTime, _openingTime, _closingTime);
        _openingTime = startTime;
    }
    

    
    function setEndTime(uint256 endTime) public onlyOwner {
        // only if CS was not ended
        require(block.timestamp < _closingTime);
        // only if new end time in future
        require(block.timestamp < endTime);
        require(endTime > _openingTime);
        emit TimesChanged(_openingTime, endTime, _openingTime, _closingTime);
        _closingTime = endTime;
    }
    

    
    function setTimes(uint256 startTime, uint256 endTime) public onlyOwner {
        require(endTime > startTime);
        uint256 oldStartTime = _openingTime;
        uint256 oldEndTime = _closingTime;
        bool changed = false;
        if (startTime != oldStartTime) {
            require(startTime > block.timestamp);
            // only if CS was not started
            require(block.timestamp < oldStartTime);
            // only move time to future
            require(startTime > oldStartTime);

            _openingTime = startTime;
            changed = true;
        }
        if (endTime != oldEndTime) {
            // only if CS was not ended
            require(block.timestamp < oldEndTime);
            // end time in future
            require(block.timestamp < endTime);

            _closingTime = endTime;
            changed = true;
        }

        if (changed) {
            emit TimesChanged(startTime, endTime, oldStartTime, oldEndTime);
        }
    }


}


