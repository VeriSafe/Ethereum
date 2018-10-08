pragma solidity ^0.4.29;


/**
 * @title DevRoles interface 
 * @dev To be called when only devs are allowed
 */
interface IDevRoles {
   function isDev(address account) external  view returns (bool);

}