// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./CpolloEscrow.sol";

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
/**
 * @title TokenEscrow
 * @dev Escrow contract that holds token funds for a specific role. Only Escrow managers can transfer funds.
 * 
 */
contract TokenEscrow is CpolloEscrow {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    // The token funds escrow 
    IERC20 private _token;
  /**
   * @param token Address of the token 
   */
    constructor( IERC20 token) public { 
        require(token != address(0), "Token can not be null");
        _token = token;
    }
  

    /**
    * @dev Transfer tokens to destination payed
    * @param payee The destination address of the funds.
    */
    function _transfer(address payee, uint256 amount) internal {
        _transfers[payee] = _transfers[payee].add(amount);
        _token.safeTransfer(payee, amount);
    }
    /**
    * @dev Transfer tokens funds back to team wallet when scam happens.
    */
    function _transferFundsScam() internal {
        uint256 totalTokenFunds = _token.balanceOf(this);
        _token.safeTransfer(_teamWallet, totalTokenFunds);
    }

}