pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";

 /**
 * @title Base Swap
 * @dev Base Swap contract, swap between tokens
 * @dev Intended usage: The owner of the token to be swaped transfer all the funds to this contract. Holders of the older token will transfer
 * to this contract as well. Call swap function to swap between tokens
 */
contract Swap is Secondary {
    using SafeMath for uint256;
    uint256 internal _totalDeposits;
    uint256 internal _totalSwapped;

    event Deposited(address indexed payee, uint256 tokenAmount);
    event Swapped(address indexed payee, uint256 tokenAmount);

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
    function totalSwapped() public view returns(uint256) {
        return _totalSwapped;
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
    * @dev called by
    */
    function swap() public {
        _preSwap(sender, payment);
        address sender = msg.sender;
        uint256 payment = _deposits[sender];
      
        _swap(sender, payment);
        _deposits[sender] = 0;

        emit Swapped(sender, payment);
    }

    function _preSwap(address payee, uint256 amount) internal {
        require(payee != address(0), "address can not be null");
        require(amount != 0, "amount can not be null");
    }

    function _deposit(address payee, uint256 amount) internal {
        _totalDeposits = _totalDeposits.add(amount);
        _deposits[payee] = _deposits[payee].add(amount);
    }

    function _swap(address sender, uint256 amount) internal {
        _totalSwapped = _totalSwapped.add(amount);
    }

    function _preDeposit(address sender, uint256 amount) internal { 
        require(sender != address(0), "address can not be null");
        require(amount != 0, "amount can not be null");
    }
}