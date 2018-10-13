// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title CpolloRoles interface 
 * @dev ICpolloRoles interface is used to check if the given address belongs to a cpollo member. 
 */
interface ICpolloRoles {
   function isCpollo(address account) external view returns (bool);

}