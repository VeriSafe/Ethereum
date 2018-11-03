// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../airdrop/distribution/TokenAirdrop.sol";
import "../airdrop/validation/KYCAirdrop.sol";
import "../access/IUserRoles.sol";
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
        KYCAirdrop(user)
        public {
            
    }
 
}
