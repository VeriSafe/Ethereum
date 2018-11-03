// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";

import "./BaseEscrow.sol";


contract EscrowManagerRole is BaseEscrow {
    using Roles for Roles.Role;

    event EscrowManagerAdded(address indexed account);
    event EscrowManagerRemoved(address indexed account);

    Roles.Role internal _escrowManager;

    constructor(address manager) public {
        _addEscrowManager(manager);
    }

    modifier onlyEscrowManager() {
        require(isEscrowManager(msg.sender), "Only EscrowManager Members allowed");
        _;
    }

    function isEscrowManager(address account) public view returns (bool) {
        return _escrowManager.has(account);
    }

    function addEscrowManager(address account) public onlyEscrowManager {
        _addEscrowManager(account);
    }

    function renounceEscrowManager() public {
        _removeEscrowManager(msg.sender);
    }

    function _addEscrowManager(address account) internal {
        _escrowManager.add(account);
        emit EscrowManagerAdded(account);
    }
    /**
    * @dev Can be overriden. The overriding function
    * should call super._removeEscrowManager(account) to ensure the chain of transfer is
    * executed entirely.
   */
    function _removeEscrowManager(address account) internal {
        _escrowManager.remove(account);
        emit EscrowManagerRemoved(account);
    }
     /**
   * @dev Can be overridden to add pre transfer logic. The overriding function
   * should call super._preTransfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_escrowManager.has(msg.sender), "You must be a Escrow Manager to do transfers in this Escrow");      
    }



}