// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./BaseWallet.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
/**
 * @title LimitedWallet
 * @dev A limited Wallet contract hold funds and limits them to a defined period of time set by the timestamp. 
 */
contract LimitedWallet is BaseWallet {
    using SafeMath for uint256;
 
    // Total Amount Payed in timestamp Interval
    uint256 private _amountPayedInInterval;
    // Total Tokens Payement limit
    uint256 private _amountPayedLimit;
    // Timestamp interval where tokens payed back to zero
    uint256 private _timestampInterval;
    // The last time where funds where resetted
    uint256 private _timestampNow;

    event LimitChanged(address indexed account, uint256 indexed newLimit);
    event TimestampIntervalChanged(address indexed account, uint256 indexed newTimestampInvterval);

   /**
   * @dev 
   * @param amountLimit Max amount value we can spend at each timestampInterval
   * @param timestampInterval Timestamp interval to reset token limit
   */
    constructor(uint256 amountLimit, uint256 timestampInterval) public { 
        require(amountLimit >0);
        require(timestampInterval > 0 );
        _amountPayedLimit = amountLimit;
        _timestampInterval = timestampInterval;
        _timestampNow = block.timestamp;
    }

   /**
   * @dev Can be overridden to add pre transfer logic. The overriding function
   * should call super._preTransfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_amountPayedInInterval.add(amount) < _amountPayedLimit, "Limit Amount passed");
        _amountPayedInInterval = _amountPayedInInterval.add(amount);
        
    }
     /**
   * @dev Call to reset amount payed, and then Wallet can do more Payments
   */
    function resetAmountTotalPayments() public {      
        require(_timestampNow.add(_timestampInterval) < block.timestamp, "Not enough time passed");
        _timestampNow = block.timestamp;
        _amountPayedInInterval = 0;
    }
    
    /** TODO - Investigate if its better allow change limits by Wallet Manager or only by
    * Cpollo 
    * @dev Change the Amount limit
    
    function changeAmountLimit(uint256 newLimit) public onlyWalletManager  { 
        require(amountLimit > 0, "Amount limit can not be under zero ");  
        _preChangeAmountLimit(newLimit);
        _amountPayedLimit = newLimit;
        emit LimitChanged(msg.sender, newLimit);
    }*/
      /**
    * @dev Change the token interval timestamp limit
    *
    function changeTimestampInterval(uint256 newTimestampInvterval) public onlyWalletManager  {  
        require(timestampInterval > 0, "timestampInterval can not be under zero ");   
         _preChangeTimestampInterval(newTimestampInvterval);
        _timestampInterval = newTimestampInvterval;
        emit TimestampIntervalChanged(msg.sender, newTimestampInvterval);
    }
    function _preChangeAmountLimit(uint256 newLimit) internal ;
    function _preChangeTimestampInterval(uint256 newTimestampInvterval) internal ;
    

    */


}