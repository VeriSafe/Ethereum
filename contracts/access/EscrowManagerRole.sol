// solium-disable linebreak-style
pragma solidity ^0.4.29;


import "openzeppelin-solidity/contracts/access/Roles.sol";

contract EscrowManagerRole {
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

    function _removeEscrowManager(address account) internal {
        _escrowManager.remove(account);
        emit EscrowManagerRemoved(account);
    }
}