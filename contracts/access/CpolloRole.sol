// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "openzeppelin-solidity/contracts/access/Roles.sol";
/**
 * @title CpolloRoles 
 * @dev Cpollo role is a public registry of all Cpollo members. 
 * Cpollo members will investigate and vett projects listed in the Cpollo platform
 */
contract CpolloRole {
    using Roles for Roles.Role;
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );
    event CpolloAdded(address indexed account);
    event CpolloRemoved(address indexed account);

    Roles.Role private _cpollos;

    constructor() public {
        _owner = msg.sender;
        _addCpollo(msg.sender);
    }

    modifier onlyCpollo() {
        require(isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }

    modifier onlyOwner() {
        require(isOwner(), "Only Cpollo Owner allowed");
        _;
    }
     /**
    * @return true if `msg.sender` is the owner of the contract.
    */
    function isOwner() public view returns(bool) {
        return msg.sender == _owner;
    }
    /**
   * @return the address of the owner.
    */
    function owner() public view returns(address) {
        return _owner;
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
        _cpollos.add(account);
        emit CpolloAdded(account);
    }

    function removeCpollo(address account) public onlyOwner {       
        _cpollos.remove(account);
        emit CpolloRemoved(account);
    }

    function _removeCpollo(address account) internal {
        _cpollos.remove(account);
        emit CpolloRemoved(account);
    }
  
    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
    * @dev Transfers control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }    

}