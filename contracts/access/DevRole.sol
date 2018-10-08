pragma solidity ^0.4.29;

import "openzeppelin-solidity/contracts/access/rbac/Roles.sol";
import "./ICpolloRoles.sol";

contract DevRole {
    using Roles for Roles.Role;

    event DevAdded(address indexed account);
    event DevRemoved(address indexed account);
    
    Roles.Role private _devs;
    ICpolloRoles _cpollo;

    constructor(ICpolloRoles cpollo) public {
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isDev(address account) public view returns (bool) {
        return _devs.has(account);
    }

    function addDev(address account) public onlyCpollo {
        _addDev(account);
    }

    function renounceDev() public {
        _removeDev(msg.sender);
    }
    function removeDev() public onlyCpollo {
        _removeDev(msg.sender);
    }

    function _addDev(address account) internal {
        _devs.add(account);
        emit DevAdded(account);
    }

    function _removeDev(address account) internal {
        _devs.remove(account);
        emit DevRemoved(account);
    }
}