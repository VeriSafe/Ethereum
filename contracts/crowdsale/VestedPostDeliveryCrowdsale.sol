// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


/**
 * @title VestedPostDeliveryCrowdsale
 * @dev Crowdsale that locks tokens from withdrawal until it ends and vests the crowdsale for 4 times.
 */
contract VestedPostDeliveryCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

 
    uint256[5] private _vestedTime;
    uint256[5] private _capToken;
    uint256 private _length;
    uint256 private _totalTokenCap;

    mapping(address => uint256) private _balances;
    /**
    * @dev Constructor, takes crowdsale opening and closing times.
    */
    constructor(uint256[] vestedTime, uint256[] capToken, uint256 length) public {
        require(vestedTime[0] >= closingTime(), "initial time distribution must be higher than closing time");
        //require(vestedTime.length == capToken.length, "Vesting times must be equal to capTokens");
        for (uint256 i = 1; i < length; i++) {
            require(vestedTime[i] >= vestedTime[i-1], "Vested time must be higher");
        }
        for (i = 0; i < length; i++) {
            _vestedTime[i] = vestedTime[i];
        }
        for (i = 0; i < length; i++) {
            _capToken[i] = capToken[i];
        }
        _length = length;
        _totalTokenCap = 0;
    }
     /**
    * @dev Test function to Withdraw tokens only after crowdsale ends and after vesting time.
    * @param beneficiary Whose tokens will be withdrawn.
    * @param amount  Whose tokens will be withdrawn.
    */
    function withdrawWillFail(address beneficiary, uint256 amount) public view returns (bool){
        require(hasClosed(),  "Crowdsale closed");
        require(amount > 0, "Amount must be higher than 0");
        uint256 totalTokenAmount = _totalTokenCap;
        totalTokenAmount = totalTokenAmount.add(amount);
        bool allowedWithdraw = false;
    
        for (uint256 i = 0; i < _length; i++) {
            allowedWithdraw = (_vestedTime[i] < block.timestamp && totalTokenAmount < _capToken[i]) || allowedWithdraw;
        }
        return  allowedWithdraw; 
    }

    /**
    * @dev Withdraw tokens only after crowdsale ends.
    * @param beneficiary Whose tokens will be withdrawn.
    */
    function withdrawTokens(address beneficiary) public{
        require(hasClosed(),  "Crowdsale closed");
        uint256 amount = _balances[beneficiary];
        require(amount > 0, "Amount must be higher than 0");
        uint256 totalTokenAmount = _totalTokenCap;
        totalTokenAmount = totalTokenAmount.add(amount);
        bool allowedWithdraw = false;
        for (uint256 i = 0; i < _length; i++) {
            allowedWithdraw = (_vestedTime[i] < block.timestamp && totalTokenAmount < _capToken[i]) || allowedWithdraw;
        }
        require(allowedWithdraw);
        
        if(allowedWithdraw){
            _totalTokenCap = _totalTokenCap.add(amount);
            _balances[beneficiary] = 0;
            _deliverTokens(beneficiary, amount);
        }
  
    }

    /**
    * @return the balance of an account.
    */
    function balanceOf(address account) public view returns(uint256) {
        return _balances[account];
    }

    /**
    * @dev Overrides parent by storing balances instead of issuing tokens right away.
    * @param beneficiary Token purchaser
    * @param tokenAmount Amount of tokens purchased
    */
    function _processPurchase(
        address beneficiary,
        uint256 tokenAmount
    )
        internal
    {
        _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
    }
  

}