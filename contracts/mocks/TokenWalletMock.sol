// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../wallet/TokenWallet.sol";
import "../wallet/CpolloWallet.sol";
import "../wallet/BaseWallet.sol";
import "../access/ICpolloRoles.sol";

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title TokenWalletMock
 * @dev Wallet that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 BaseWallet, CpolloWallet,
*/
contract TokenWalletMock is TokenWallet  {
    constructor(
        address teamWallet, 
        ICpolloRoles cpollo,
        IERC20 token
        )   
        BaseWallet()
        CpolloWallet( teamWallet, cpollo) 
        TokenWallet(token)          
        public {
            
    }
 
}
