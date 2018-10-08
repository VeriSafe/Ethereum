// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "../access/EscrowManagerRole.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title BaseEscrow
 * @dev Base escrow with Management role
 * 
 */
contract BaseEscrow is EscrowManagerRole {
 
    using SafeMath for uint256;
    
    event Transfered(address indexed payee, address indexed payeedBy, uint256 tokenAmount);

    mapping(address => uint256) internal _transfers;
    constructor(address manager) EscrowManagerRole(manager) public {

    }

    function transfersOf(address payee) public view returns (uint256) {
        return _transfers[payee];
    }
    /**
    * @dev Transfer Assets to destination payed ***DO NOT OVERRIDE***
    * @param payee The destination address of the funds.
    */
    function transfer(address payee, uint256 amount) public {
        _preTransfer(payee, amount);
        require(_escrowManager.has(msg.sender), "You must be a Escrow Manager");
        _transfer(payee, amount);
        emit Transfered(payee, msg.sender, amount);
    }
   /**
   * @dev Can be overridden to add pre transfer logic. The overriding function
   * should call super._preTransfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _preTransfer(address payee, uint256 amount) internal {
        require(payee != address(0));
        require(amount != 0);
    }
     /**
   * @dev Needs to be overriden. The overriding function
   * should call super._transfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _transfer(address payee, uint256 amount) internal;
}