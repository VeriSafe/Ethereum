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

   
    uint256 private vestedTime1;
    uint256 private vestedTime2;
    uint256 private vestedTime3;
    uint256 private vestedTime4;
    uint256 private _capToken1;
    uint256 private _capToken2;
    uint256 private _capToken3;
    uint256 private _capToken4;
    uint256 private _totalTokenCap;

    mapping(address => uint256) private _balances;
    /**
    * @dev Constructor, takes crowdsale opening and closing times.
    * @param openingTime Crowdsale opening time
    * @param closingTime Crowdsale closing time
    */
    constructor(uint256 vestedTime1, uint256 vestedTime2, uint256 vestedTime3, uint256 vestedTime4
            , uint256 capToken1, uint256 capToken2, uint256 capToken3, uint256 capToken4) public {


        require(vestedTime1 >= closingTime);
        require(vestedTime2 >= vestedTime1);
        require(vestedTime3 >= vestedTime2);
        require(vestedTime4 >= vestedTime3);
    }



    /**
    * @dev Withdraw tokens only after crowdsale ends.
    * @param beneficiary Whose tokens will be withdrawn.
    */
    function withdrawTokens(address beneficiary) public {
        require(hasClosed(), "Crowdsale closed");
        uint256 amount = _balances[beneficiary];
        require(amount > 0, "Crowdsale closed");
        uint256 totalTokenAmount = _totalTokenCap;
        totalTokenAmount = totalTokenAmount.add(amount);
        require(
        (vestedTime1 >= block.timestamp && totalTokenAmount <= _capToken1) ||
        (vestedTime2 >= block.timestamp && totalTokenAmount <= _capToken2) ||
        (vestedTime3 >= block.timestamp && totalTokenAmount <= _capToken3) ||
        (vestedTime4 >= block.timestamp && totalTokenAmount <= _capToken4) 
        );

        _totalTokenCap = _totalTokenCap.add(amount);
        _balances[beneficiary] = 0;
        _deliverTokens(beneficiary, amount);
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