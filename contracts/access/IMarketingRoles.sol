// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title MarketingRoles interface 
 * @dev 
 */
interface IMarketingRoles {
   function isMarketing(address account) external  view returns (bool);
}