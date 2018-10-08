// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title ManagerRoles interface 
 * @dev 
 */
interface ILegalRoles {
   function isLegal(address account) external  view returns (bool);

}