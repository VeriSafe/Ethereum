// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../access/CpolloRole.sol";

contract CpolloRoleMock is CpolloRole {

    function onlyCpolloMock() public view onlyCpollo {
    }

}