// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./BaseWallet.sol";
import "../access/IDevRoles.sol";
/**
 * @title DevTokenWallet
 * @dev This is the Wallet that holds funds for development. 
 * Only registered Developers are allowed to receive token funds.
 *  When there are signals of a scam, Cpollo will freeze the funds and start the auditing process. 
 * If the signals are determined to be correct, Cpollo will return funds to the team wallet.
 */
contract DevRoleWallet is BaseWallet {

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
