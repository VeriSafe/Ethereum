// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title ManagerRoles interface 
 * @dev IManagerRoles interface is used to check if the given address belongs to a manager
 */
interface IManagerRoles {
   function isManager(address account) external  view returns (bool);
}
