// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title ManagerRoles interface 
 * @dev 
 */
interface IManagerRoles {
   function isManager(address account) external  view returns (bool);
}
