// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./BaseEscrow.sol";
import "../access/IMarketingRoles.sol";

/**
 * @title DevTokenEscrow
 * @dev This is the escrow that holds funds for Marketing. 
 *  Only individuals registered on the marketing team are allowed to receive token funds. 
 *  When there are signals of a scam, Cpollo will freeze the funds to start the auditing process. 
 * If these signals are right, Cpollo will return funds to the team wallet.
 */
contract MarketingTokenEscrow is BaseEscrow {

    IMarketingRoles private _marketeer;
    
    constructor(IMarketingRoles marketeer ) public {
        _marketeer = marketeer;
    }

    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_marketeer.isMarketeer(payee), "Only Marketeers allowed to receive funds");
    }

 
}
