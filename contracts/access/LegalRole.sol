pragma solidity ^0.4.29;

import "https://github.com/Cpollo/openzeppelin-solidity/contracts/access/Roles.sol";

contract CpolloRole {
  using Roles for Roles.Role;

  event CpolloAdded(address indexed account);
  event CpolloRemoved(address indexed account);

  Roles.Role private cpollos;

  constructor() public {
    _addCpollo(msg.sender);
  }

  modifier onlyCpollo() {
    require(isCpollo(msg.sender), "Only Cpollo Members allowed");
    _;
  }

  function isCpollo(address account) public view returns (bool) {
    return cpollos.has(account);
  }

  function addCpollo(address account) public onlyCpollo {
    _addCpollo(account);
  }

  function renounceCpollo() public {
    _removeCapper(msg.sender);
  }

  function _addCpollo(address account) internal {
    cpollos.add(account);
    emit CpolloAdded(account);
  }

  function _removeCpollo(address account) internal {
    cpollos.remove(account);
    emit CpolloRemoved(account);
  }
}