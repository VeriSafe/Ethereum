// solium-disable linebreak-style
pragma solidity ^0.4.24;
import "../access/ICpolloRoles.sol";
import "../access/UserRole.sol";

contract UserRoleMock is UserRole {
    constructor(
        ICpolloRoles _cpollo
        )   
        UserRole(_cpollo) 
        public {
            
    }
   
    function onlyUserMock() public view onlyCpollo {
    }

}