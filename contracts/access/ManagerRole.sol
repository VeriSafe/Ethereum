// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./ICpolloRoles.sol";
/**
 * @title ManagerRole
 * @dev ManagerRole role is a public registry of all manager members. Manager members can receive funds from manager escrow's.  Only Cpollo members can
 * add managers to the public registry.
 */
contract ManagerRole {
    using Roles for Roles.Role;

    event ManagerAdded(address indexed account);
    event ManagerRemoved(address indexed account);
    
    Roles.Role private _managers;
    ICpolloRoles _cpollo;

    constructor(ICpolloRoles cpollo) public {
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isManager(address account) public view returns (bool) {
        return _managers.has(account);
    }

    function addManager(address account) public onlyCpollo {
        _addManager(account);
    }

    function renounceManager() public {
        _removeManager(msg.sender);
    }
    function removeManager() public onlyCpollo {
        _removeManager(msg.sender);
    }

    function _addManager(address account) internal {
        _managers.add(account);
        emit ManagerAdded(account);
    }

    function _removeManager(address account) internal {
        _managers.remove(account);
        emit ManagerRemoved(account);
    }
}