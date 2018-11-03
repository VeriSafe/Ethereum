// solium-disable linebreak-style
pragma solidity ^0.4.24;

 * @title UserRoles interface 
 * @dev IUserRoles interface is used to check if the given address belongs to a user member. 
 */
interface IUserRoles {
   function isUser(address account) external view returns (bool);
} 

