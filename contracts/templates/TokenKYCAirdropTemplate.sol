// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../escrow/TokenEscrow.sol";
import "../escrow/CpolloEscrow.sol";
import "../escrow/LimitedEscrow.sol";
import "../escrow/DevRoleEscrow.sol";
import "../escrow/EscrowManagerRole.sol";
import "../access/ICpolloRoles.sol";
import "../access/IDevRoles.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

/**
 * @title TokenKYCAirdropTemplate
 * @dev TokenKYCAirdropTemplate to be used in KYC verified users and to airdrop tokens to users
 */

contract TokenKYCAirdropTemplate is  TokenAirdrop, KYCAirdrop {
    constructor(
        IUserRoles user,
        IERC20 token,
        address wallet
        )   
        TokenAirdrop(token, wallet) 
        KYCAirdrop(token)
        public {
            
    }
 
}
