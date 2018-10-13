// solium-disable linebreak-style
pragma solidity ^0.4.24;
import "../access/ICpolloRoles.sol";
import "../access/ManagerRole.sol";

contract ManagerRoleMock is ManagerRole {
    constructor(
        ICpolloRoles _cpollo
        )   
        ManagerRole(_cpollo) 
        public {
            
    }
   
    function onlyManagerMock() public view onlyCpollo {
    }
    function removeManager(address account) public onlyCpollo{
        _removeManager(account);
    }
  

}