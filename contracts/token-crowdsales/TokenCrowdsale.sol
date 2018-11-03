pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title TokenCrowdsale
 * @dev TokenCrowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with tokens. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract TokenCrowdsale {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // The token being sold
    IERC20 private _token;

    // The exchange token being exchanged
    IERC20 private _tokenExchange;

    // Address where funds are collected
    address private _wallet;

    // How many token units a buyer gets per tokens.
    // The rate is the conversion between token unit being  and the smallest and indivisible token unit.
    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
    // 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 private _rate;

    // Amount of tokens raised
    uint256 private _tokenRaised;

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
    event TokensPurchased(
      address indexed purchaser,
      address indexed beneficiary,
      uint256 value,
      uint256 amount
    );

  /**
   * @param rate Number of token units a buyer gets per wei
   * @dev The rate is the conversion between wei and the smallest and indivisible
   * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
   * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
   * @param wallet Address where collected funds will be forwarded to
   * @param token Address of the token being sold
   */
    constructor(uint256 rate, address wallet, IERC20 token, IERC20 tokenExchange) public {
        require(rate > 0);
        require(wallet != address(0));
        require(token != address(0));
        require(tokenExchange != address(0));

        _rate = rate;
        _wallet = wallet;
        _token = token;
        _tokenExchange = _tokenExchange;
    }

    // -----------------------------------------
    // Crowdsale external interface
    // -----------------------------------------
    /**
    * @return the token being sold.
    */
    function token() public view returns(IERC20) {
        return _token;
    }
    /**
    * @return the token being exchanged.
    */
    function tokenExchange() public view returns(IERC20) {
        return _tokenExchange;
    }

    /**
    * @return the address where funds are collected.
    */
    function wallet() public view returns(address) {
        return _wallet;
    }

    /**
    * @return the number of token units a buyer gets per wei.
    */
    function rate() public view returns(uint256) {
        return _rate;
    }

    /**
    * @return the mount of wei raised.
    */
    function tokenRaised() public view returns (uint256) {
        return _tokenRaised;
    }

    /**
    * @dev low level token purchase ***DO NOT OVERRIDE***
    * @param beneficiary Address performing the token purchase
    */
    function buyTokens(address beneficiary, uint256 amount) public {
   
        _preValidatePurchase(beneficiary, amount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(amount);

        // update state
        _tokenRaised = _tokenRaised.add(amount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(
            msg.sender,
            beneficiary,
            amount,
            tokens
        );

        _updatePurchasingState(beneficiary, amount);

        _forwardTokenFunds(beneficiary, amount);
        _postValidatePurchase(beneficiary, amount);
    }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

    /**
    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
    *   super._preValidatePurchase(beneficiary, amount);
    *   require(tokenRaised().add(amount) <= cap);
    * @param beneficiary Address performing the token purchase
    * @param amount Value in tokens involved in the purchase
    */
    function _preValidatePurchase(
        address beneficiary,
        uint256 amount
    )
      internal
    {
        require(beneficiary != address(0));
        require(amount != 0);
        require(_tokenExchange.allowance(beneficiary, address(this)) <= amount, "You need to approve first the amount to this contract address");
    }

    /**
    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
    * @param beneficiary Address performing the token purchase
    * @param amount Value in tokens involved in the purchase
    */
    function _postValidatePurchase(
        address beneficiary,
        uint256 amount
    )
      internal
    {
      // optional override
    }

    /**
    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
    * @param beneficiary Address performing the token purchase
    * @param tokenAmount Number of tokens to be emitted
    */
    function _deliverTokens(
        address beneficiary,
        uint256 tokenAmount
    )
      internal
    {
        _token.safeTransfer(beneficiary, tokenAmount);
    }

    /**
    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
    * @param beneficiary Address receiving the tokens
    * @param tokenAmount Number of tokens to be purchased
    */
    function _processPurchase(
        address beneficiary,
        uint256 tokenAmount
    )
      internal
    {
        _deliverTokens(beneficiary, tokenAmount);
    }

    /**
    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
    * @param beneficiary Address receiving the tokens
    * @param weiAmount Value in wei involved in the purchase
    */
    function _updatePurchasingState(
        address beneficiary,
        uint256 weiAmount
    )
      internal
    {
      // optional override
    }

    /**
    * @dev Override to extend the way in which ether is converted to tokens.
    * @param amount Value in tokens to be converted into tokens
    * @return Number of tokens that can be purchased with the specified _weiAmount
    */
    function _getTokenAmount(uint256 amount)
      internal view returns (uint256)
    {
        return amount.mul(_rate);
    }

    /**
    * @dev Determines how Tokens are stored/forwarded on purchases.
    */
    function _forwardTokenFunds(address beneficiary, uint256 amount) internal {
        _token.safeTransferFrom(beneficiary, _wallet, amount);
    }
}
