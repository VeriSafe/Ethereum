// solium-disable linebreak-style
pragma solidity ^0.4.24;


/**
 * @title MarketingRoles interface 
 * @dev IMarketingRoles interface is used to check if the given address belongs to a marketeer
 */
interface IMarketingRoles {
   function isMarketeer(address account) external  view returns (bool);
}