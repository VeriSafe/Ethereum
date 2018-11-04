pragma solidity ^0.4.24;

import "../TokenCrowdsale.sol";
import "../../access/IUserRoles.sol";
/**
 * @title TokenKYCCrowdsale
 * @dev TokenKYCCrowdsale only can be bought from verified users
 */
contract TokenKYCCrowdsale is TokenCrowdsale {

    IUserRoles private _user;

    constructor(IUserRoles user ) public {
        require(user != address(0), "User can not be null");
        _user = user;
    }

    /**
    * @dev Extend parent behavior requiring to be within contributing period
    * @param _beneficiary Token purchaser
    * @param _amount Amount of token contributed
    */
    function _preValidatePurchase(
        address _beneficiary,
        uint256 _amount
    )
        internal
    {
        super._preValidatePurchase(_beneficiary, _amount);
        require(_user.isUser(_beneficiary), "Only KYC users can buy");
    }
    
 

}


