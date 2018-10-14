// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";
import "./ICpolloRoles.sol";

/**
 * @title LegalRole
 * @dev LegalRole role is a public registry of all legal members.Legal members can receive funds from legal escrow's.  Only Cpollo members can
 * add legals to the public registry.
 */
contract LegalRole {
    using Roles for Roles.Role;

    event LegalAdded(address indexed account);
    event LegalRemoved(address indexed account);
    
    Roles.Role private _legals;
    ICpolloRoles _cpollo;

    constructor(ICpolloRoles cpollo) public {
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isLegal(address account) public view returns (bool) {
        return _legals.has(account);
    }

    function addLegal(address account) public onlyCpollo {
        _addLegal(account);
    }

    function renounceLegal() public {
        _removeLegal(msg.sender);
    }
    function removeLegal(address account) public onlyCpollo {
        _removeLegal(acciou);
    }

    function _addLegal(address account) internal {
        _legals.add(account);
        emit LegalAdded(account);
    }

    function _removeLegal(address account) internal {
        _legals.remove(account);
        emit LegalRemoved(account);
    }
}