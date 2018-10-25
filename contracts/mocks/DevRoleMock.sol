// solium-disable linebreak-style
pragma solidity ^0.4.24;
import "../access/ICpolloRoles.sol";
import "../access/DevRole.sol";

contract DevRoleMock is DevRole {
    constructor(
        ICpolloRoles _cpollo
        )   
        DevRole(_cpollo) 
        public {
            
    }
   
    function onlyDevMock() public view onlyCpollo {
    }

}