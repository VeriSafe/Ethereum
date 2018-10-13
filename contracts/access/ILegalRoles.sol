// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title LegalrRoles interface 
 * @dev ILegalRoles interface is used to check if the given address belongs to a legal
 */
interface ILegalRoles {
   function isLegal(address account) external  view returns (bool);

}