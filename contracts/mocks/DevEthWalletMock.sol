// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../wallet/TokenWallet.sol";
import "../wallet/CpolloWallet.sol";
import "../wallet/EthWallet.sol";
import "../wallet/LimitedWallet.sol";
import "../wallet/DevRoleWallet.sol";
import "../wallet/WalletManagerRole.sol";
import "../access/ICpolloRoles.sol";
import "../access/IDevRoles.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title DevEthWalletMock
 * @dev Wallet that holds funds for development, only registered Devs are allowed to receive eth funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 */

contract DevEthWalletMock is  EthWallet, WalletManagerRole, LimitedWallet, DevRoleWallet {
    constructor(
        IDevRoles dev, 
        uint256 amountLimit, 
        uint256 timestampInterval,
        address teamWallet, 
        ICpolloRoles cpollo,
        address manager
        )   
        CpolloWallet(teamWallet, cpollo) 
        EthWallet()
        WalletManagerRole(manager)
        LimitedWallet(amountLimit, timestampInterval)
        DevRoleWallet(dev)
        public 
        payable
        {
            
        }
 
}
