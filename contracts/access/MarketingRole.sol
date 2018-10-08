// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./ICpolloRoles.sol";

contract MarketingRole {
    using Roles for Roles.Role;

    event MarketingAdded(address indexed account);
    event MarketingRemoved(address indexed account);
    
    Roles.Role private _markeeters;
    ICpolloRoles _cpollo;

    constructor(ICpolloRoles cpollo) public {
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isMarketing(address account) public view returns (bool) {
        return _markeeters.has(account);
    }

    function addMarketing(address account) public onlyCpollo {
        _addMarketing(account);
    }

    function renounceMarketing() public {
        _removeMarketing(msg.sender);
    }
    function removeMarketing() public onlyCpollo {
        _removeMarketing(msg.sender);
    }

    function _addMarketing(address account) internal {
        _markeeters.add(account);
        emit MarketingAdded(account);
    }

    function _removeMarketing(address account) internal {
        _markeeters.remove(account);
        emit MarketingRemoved(account);
    }
}