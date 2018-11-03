pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "./TokenAirdrop.sol";
 /**
 * @title Mintable Token Airdrop
 * @dev Mintable Token Airdrop contract, 
 * @dev Intended usage: User will transfer token funds in order to do airdrop 
 */
contract MintTokenAirdrop is Airdrop {
    IERC20 private _token;

    constructor( IERC20 token) public { 
        require(token != address(0), "Token can not be null");
        _token = token;
    }
    /**
    *
    * @dev Overriding implementation
     */
    function _withdraw(address sender, uint256 amount) internal {
        // Potentially dangerous assumption about the type of the token.
        require(ERC20Mintable(address(_token)).mint(sender, amount), "Not Mintable token");
        super._withdraw(sender, amount);
    }
  
}