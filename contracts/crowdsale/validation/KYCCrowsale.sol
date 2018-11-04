pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol";
import "../../access/IUserRoles.sol";
/**
 * @title KYCCrowdsale
 * @dev KYCCrowdsale only can be bought from verified users
 */
contract KYCCrowdsale is Crowdsale {

    IUserRoles private _user;

    constructor(IUserRoles user ) public {
        require(user != address(0), "User can not be null");
        _user = user;
    }

    /**
    * @dev Extend parent behavior requiring to be within contributing period
    * @param _beneficiary purchaser
    * @param _weiAmount Amount of wei contributed
    */
    function _preValidatePurchase(
        address _beneficiary,
        uint256 _weiAmount
    )
        internal
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        require(_user.isUser(_beneficiary), "Only KYC users can buy");
    }
    
 

}


