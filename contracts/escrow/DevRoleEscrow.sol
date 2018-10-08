// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./TokenEscrow.sol";
import "../access/ICpolloRoles.sol";
import "../access/IDevRoles.sol";
/**
 * @title DevTokenEscrow
 * @dev Escrow that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 */
contract DevRoleEscrow is BaseEscrow {

    IDevRoles private _dev;

    constructor(IDevRoles dev ) public {
        require(dev != address(0), "Dev can not be null");
        _dev = dev;
    }

    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_dev.isDev(payee), "Only Devs allowed to receive funds");
    }

 
}
