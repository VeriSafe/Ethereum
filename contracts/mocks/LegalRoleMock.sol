// solium-disable linebreak-style
pragma solidity ^0.4.24;
import "../access/ICpolloRoles.sol";
import "../access/LegalRole.sol";

contract LegalRoleMock is LegalRole {
    constructor(
        ICpolloRoles _cpollo
        )   
        LegalRole(_cpollo) 
        public {
            
    }
   
    function onlyLegalMock() public view onlyCpollo {
    }
    function removeLegal(address account) public onlyCpollo{
        _removeLegal(account);
    }
  

}