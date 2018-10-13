// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title DevRoles interface 
 * @dev IDevRoles interface is used to check if the given address belongs to a dev
 */
interface IDevRoles {
   function isDev(address account) external  view returns (bool);

}