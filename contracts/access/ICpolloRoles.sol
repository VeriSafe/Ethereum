pragma solidity ^0.4.29;


/**
 * @title CpolloRoles interface 
 * @dev Call isCpollo to killswitch features
 */
interface ICpolloRoles {
   function isCpollo(address account) external  view returns (bool);

}