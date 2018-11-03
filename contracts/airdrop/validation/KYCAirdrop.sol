pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../Airdrop.sol";
import "../../access/IUserRoles.sol";

 /**
 * @title KYC Airdrop
 * @dev KYC Airdrop contract, only KYC users will get the airdrop
 * @dev Intended usage:
 */
contract KYCAirdrop is Airdrop {
    using SafeMath for uint256;
    IUserRoles private _user;
    constructor(IUserRoles user ) public {
        require(user != address(0), "User can not be null");
        _user = user;
    }

     /**
   * @param payee Address of the user who will receive airdrop
   * @param amount tokens value to be received in airdrop
   */
    function _preDeposit(address payee, uint256 amount) internal {
        super._preDeposit(payee, amount);
        require(_user.isUser(payee), "Only KYC users are allowed");
    }

}