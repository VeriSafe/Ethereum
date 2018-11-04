// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title BaseWallet
 * @dev Base Wallet handles funds with destinations to specific roles.
 * This contract implements a base Wallet- functionality in its most fundamental form and can be extended to provide 
 * additional functionality and/or custom behavior. 
 * The external interface represents the basic interface to transfer funds to the role destination. 
 * They are *not* intended to be modified / overridden. The internal interface conforms the extensible and modifiable surface of Wallets. 
 * Override the methods to add functionality. Consider using 'super' where appropriate to concatenate behavior.
 * 
 */
contract BaseWallet {
    address public creator;
    using SafeMath for uint256;
    
    event Transfered(address indexed payee, address indexed payeedBy, uint256 tokenAmount);

    mapping(address => uint256) internal _transfers;

    constructor() public {
        creator = msg.sender;
    }

    function transfersOf(address payee) public view returns (uint256) {
        return _transfers[payee];
    }
    /**
    * @dev Transfer Assets to destination payed ***DO NOT OVERRIDE***
    * @param payee The destination address of the funds.
    * @param amount Amount to be transfered.
    */
    function transfer(address payee, uint256 amount) public {
        _preTransfer(payee, amount);
        _transfer(payee, amount);
        emit Transfered(payee, msg.sender, amount);
    }

   /**
   * @dev Can be overridden to add pre transfer logic. The overriding function
   * should call super._preTransfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _preTransfer(address payee, uint256 amount) internal {
        require(payee != address(0), "Address can not be null");
        require(amount > 0, "Amount must be higher than 0");
    }
     /**
   * @dev Needs to be overriden. The overriding function
   * should call super._transfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _transfer(address payee, uint256 amount) internal;
    
}