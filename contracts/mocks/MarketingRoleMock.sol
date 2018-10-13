// solium-disable linebreak-style
pragma solidity ^0.4.24;
import "../access/ICpolloRoles.sol";
import "../access/MarketingRole.sol";

contract MarketingRoleMock is MarketingRole {
    constructor(
        ICpolloRoles _cpollo
        )   
        MarketingRole(_cpollo) 
        public {
            
    }
   
    function onlyMarketingMock() public view onlyCpollo {
    }
    function removeMarketing(address account) public onlyCpollo{
        _removeMarketing(account);
    }
  

}