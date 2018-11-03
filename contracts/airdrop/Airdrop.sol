pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";

 /**
 * @title Base Airdrop
 * @dev Base Airdrop contract, holds funds designated for a payee until they
 * withdraw them. Intended usage: Owner of aidrop transfer an amount of tokens to be Airdroped
 */
contract Airdrop is Secondary {
    using SafeMath for uint256;
    uint256 private _totalDeposits;
    uint256 private _totalAirdrops;

    event Deposited(address indexed payee, uint256 amount);
    event Withdrawn(address indexed payee, uint256 amount);

    mapping(address => uint256) private _deposits;

    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }
    /**
    * @return total deposits
    */
    function totalDeposits() public view returns(uint256) {
        return _totalDeposits;
    }
    /**
    * @return total Airdrops
    */
    function totalAirdrops() public view returns(uint256) {
        return _totalAirdrops;
    }

    /**
    * @dev Stores the sent amount as credit to be withdrawn.
    * @param payee The destination address of the funds.
    * @param amount The amount to deposit.
    */
    function deposit(address payee, uint256 amount) public onlyPrimary {
        _preDeposit(payee, amount);
        _deposit(payee, amount);
      
        emit Deposited(payee, amount);
    }

    /**
    * @dev Withdraw accumulated balance for a payee.
    */
    function withdraw() public {
        address sender = msg.sender;
        uint256 payment = _deposits[sender];
        _preWithdraw(sender, payment);
     
      
        _withdraw(sender, payment);
        _deposits[sender] = 0;

        emit Withdrawn(sender, payment);
    }
    /**
   *
   * @dev pre deposit logic
   * @param payee Address of the sender to receive aidrop
   * @param amount tokens to be deposited
   */
    function _preDeposit(address payee, uint256 amount) internal {
        require(payee != address(0), "address can not be null");
        require(amount != 0, "amount can not be null");
    }
      /**
   *
   * @dev deposit logic
   * @param payee Address of the sender to receive aidrop
   * @param amount tokens to be deposited
   */
    function _deposit(address payee, uint256 amount) internal {
        _totalDeposits = _totalDeposits.add(amount);
        _deposits[payee] = _deposits[payee].add(amount);
    }
     /**
   *
   * @dev withdraw logic
   * @param sender Address of the sender to receive aidrop
   * @param amount tokens to be withdrawed
   */
    function _withdraw(address sender, uint256 amount) internal {
        _totalAirdrops = _totalAirdrops.add(amount);
    }
   /**
   *
   * @dev pre withdraw logic
   * @param sender Address of the sender to receive aidrop
   * @param amount tokens to be withdrawed
   */
    function _preWithdraw(address sender, uint256 amount) internal { 
        require(sender != address(0), "address can not be null");
        require(amount != 0, "amount can not be null");
    }
}