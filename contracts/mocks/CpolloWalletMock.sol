// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "../wallet/CpolloWallet.sol";
import "../wallet/BaseWallet.sol";
import "../access/ICpolloRoles.sol";
/**
 * @title CpolloWalletMock
 * @dev Wallet that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
*/
contract CpolloWalletMock is  CpolloWallet {
    constructor(
            address teamWallet, 
            ICpolloRoles cpollo
        )   
        BaseWallet()
        CpolloWallet(teamWallet, cpollo) 
        public {
            
    }
     /**
    * @dev Must Override. Where the funds are transfered when Scam happens.
    */
    function _transferFundsScam() internal {

    }
      /**
    * @dev Must Override. Where the funds are transfered when Scam happens.
    */
    function _transfer() internal {

    } 
 
}
