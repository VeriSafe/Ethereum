// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./ICpolloRoles.sol";
/**
 * @title UserRole
 * @dev UserRole role is a public registry of all verified users of Cpollo platform. Users in this registry can receive airdrops or buy whitelisted crowdsales
 */
contract UserRole {
    using Roles for Roles.Role;

    event UserAdded(address indexed account);
    event UserRemoved(address indexed account);
    
    Roles.Role private _users;
    ICpolloRoles _cpollo;

    constructor(ICpolloRoles cpollo) public {
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isUser(address account) public view returns (bool) {
        return _users.has(account);
    }

    function addUser(address account) public onlyCpollo {
        _addUser(account);
    }

    function renounceUser() public {
        _removeUser(msg.sender);
    }
    function removeUser(address account) public onlyCpollo {
        _removeUser(account);
    }

    function _addUser(address account) internal {
        _users.add(account);
        emit UserAdded(account);
    }

    function _removeUser(address account) internal {
        _users.remove(account);
        emit UserRemoved(account);
    }
}