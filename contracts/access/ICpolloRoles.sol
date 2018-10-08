// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title CpolloRoles interface 
 * @dev Call isCpollo to killswitch features
 */
interface ICpolloRoles {
   function isCpollo(address account) external  view returns (bool);

}