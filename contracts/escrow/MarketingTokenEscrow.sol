// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./TokenEscrow.sol";
import "../access/IMarketingRoles.sol";

/**
 * @title DevTokenEscrow
 * @dev Escrow that holds funds for Marketing, only registered Marketeers are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 */
contract MarketingTokenEscrow is TokenEscrow {

    IMarketingRoles private _marketeer;
    
    constructor(IMarketingRoles marketeer ) public {
        _marketeer = marketeer;
    }

    function _preTransfer(address payee, uint256 amount) private {
        super._preTransfer(payee, amount);
        require(_marketeer.isMarketeer(payee), "Only Marketeers allowed to receive funds");
    }

 
}
