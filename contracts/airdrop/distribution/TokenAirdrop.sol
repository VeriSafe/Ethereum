pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "../Airdrop.sol";
 /**
 * @title Token Airdrop
 * @dev Token Airdrop contract, 
 * @dev Intended usage: User will transfer token funds in order to do airdrop 
 */
contract TokenAirdrop is Airdrop {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    // The token funds escrow 
    IERC20 private _token;
    address private _wallet;
  /**
   * @param token Address of the token 
   * @param wallet Address of the wallet to refund remain tokens
   */
    constructor( IERC20 token, address wallet) public { 
        require(token != address(0), "Token can not be null");
        require(wallet != address(0), "Wallet can not be null");
        _token = token;
        _wallet = wallet;
    }
    /**
   *
   * @dev In order to deposit make sure Airdrop contract have sufficient token funds
   */
    function _preDeposit(address sender, uint256 amount) internal { 
        super._preDeposit(sender, amount);
        require(_totalDeposits.sub(totalAirdrops()) >= _token.balanceOf(address(this)), "You must have sufficient tokens to do airdrop");
    }

    function _withdraw(address sender, uint256 amount) internal {
        super._withdraw(sender, amount);
        _token.safeTransfer(sender, amount);
    }
    /**
    * @dev Return not used tokens back to the owner
     */
    function claimFunds() public onlyPrimary {
        _token.safeTransfer(_wallet, _token.balanceOf(address(this)));
    }


}