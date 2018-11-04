pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../TokenCrowdsale.sol";

/**
 * @title TokenCappedCrowdsale
 * @dev TokenCrowdsale with a limit for total contributions.
 */
contract TokenCappedCrowdsale is TokenCrowdsale {
    using SafeMath for uint256;

    uint256 private _cap;

    /**
    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
    * @param cap Max amount of wei to be contributed
    */
    constructor(uint256 cap) public {
        require(cap > 0);
        _cap = cap;
    }

    /**
    * @return the cap of the crowdsale.
    */
    function cap() public view returns(uint256) {
        return _cap;
    }

    /**
    * @dev Checks whether the cap has been reached.
    * @return Whether the cap was reached
    */
    function capReached() public view returns (bool) {
        return tokenRaised() >= _cap;
    }

    /**
    * @dev Extend parent behavior requiring purchase to respect the funding cap.
    * @param beneficiary Token purchaser
    * @param amount Amount of wei contributed
    */
    function _preValidatePurchase(
        address beneficiary,
        uint256 amount
    )
      internal
    {
        super._preValidatePurchase(beneficiary, amount);
        require(tokenRaised().add(amount) <= _cap);
    }

}
