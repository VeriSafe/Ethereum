// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title DevRoles interface 
 * @dev To be called when only devs are allowed
 */
interface IDevRoles {
   function isDev(address account) external  view returns (bool);

}