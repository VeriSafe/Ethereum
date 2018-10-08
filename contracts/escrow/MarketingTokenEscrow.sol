pragma solidity ^0.4.24;

import "./TokenEscrow.sol";
import "../access/ICpolloRoles.sol";
import "../access/DevRoles.sol";
/**
 * @title DevTokenEscrow
 * @dev Escrow that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 */
contract DevTokenEscrow is TokenEscrow {

    constructor(IDevRoles dev ) public {
        _dev = dev;
    }

    function _preTransfer(payee, amount) private {
        super._preTransfer(payee, amount);
        require(_state == State.Active, "Escrow must be active");
        require(_dev.isDev(payee), "Only Devs allowed to receive funds");
    }

 
}
