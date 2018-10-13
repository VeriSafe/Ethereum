// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../escrow/TokenEscrow.sol";
import "../escrow/CpolloEscrow.sol";
import "../escrow/BaseEscrow.sol";
import "../access/ICpolloRoles.sol";

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title TokenEscrowMock
 * @dev Escrow that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 BaseEscrow, CpolloEscrow,
*/
contract TokenEscrowMock is TokenEscrow  {
    constructor(
        address teamWallet, 
        ICpolloRoles cpollo,
        IERC20 token
        )   
        BaseEscrow()
        CpolloEscrow( teamWallet, cpollo) 
        TokenEscrow(token)          
        public {
            
    }
 
}
