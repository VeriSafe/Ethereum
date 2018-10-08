pragma solidity ^0.4.29;


import "openzeppelin-solidity/contracts/access/rbac/Roles.sol";

contract CpolloRole {
    using Roles for Roles.Role;

    event CpolloAdded(address indexed account);
    event CpolloRemoved(address indexed account);

    Roles.Role private _cpollos;

    constructor() public {
        _addCpollo(msg.sender);
    }

    modifier onlyCpollo() {
        require(isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    function isCpollo(address account) public view returns (bool) {
        return _cpollos.has(account);
    }

    function addCpollo(address account) public onlyCpollo {
        _addCpollo(account);
    }

    function renounceCpollo() public {
        _removeCpollo(msg.sender);
    }

    function _addCpollo(address account) internal {
        cpollos.add(account);
        emit CpolloAdded(account);
    }

    function _removeCpollo(address account) internal {
        _cpollos.remove(account);
        emit CpolloRemoved(account);
    }
}