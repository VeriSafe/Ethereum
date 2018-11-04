pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";

/**
 * @title Token Escrow
 * @dev Base token escrow contract, holds token funds destinated to a payee until they
 * withdraw them. The contract that uses the token escrow as its payment method
 * should be its primary, and provide public methods redirecting to the token escrow's
 * deposit and withdraw.
 */
contract TokenEscrow is Secondary {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint256) private _deposits;
       // The token funds Wallet 
    IERC20 private _token;
  /**
   * @param token Address of the token 
   */
    constructor( IERC20 token) public { 
        require(token != address(0), "Token can not be null");
        _token = token;
    }
    
    function token() public view returns (IERC20) {
        return _token;
    }

    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }

    /**
    * @dev Stores the sent amount as credit to be withdrawn.
    * @param payee The destination address of the funds.
    */
    function deposit(address payee, uint256 tokenAmount ) public onlyPrimary {
        uint256 amount = tokenAmount;
        _deposits[payee] = _deposits[payee].add(amount);
        emit Deposited(payee, amount);
    }

    /**
    * @dev Withdraw accumulated token balance for a payee.
    * @param payee The address whose funds will be withdrawn and transferred to.
    */
    function withdraw(address payee) public onlyPrimary {
        uint256 payment = _deposits[payee];
        _deposits[payee] = 0;
        _token.safeTransfer(payee, payment);
        emit Withdrawn(payee, payment);
    }
}
