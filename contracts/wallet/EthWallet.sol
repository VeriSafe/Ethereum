// solium-disable linebreak-style
pragma solidity ^0.4.24;


import "./CpolloWallet.sol";
// solium-disable linebreak-style
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title EthWallet
 * @dev Eth Wallet is a contract that holds eth funds destined for a specific role. The funds are supervised by Cpollo. 
 * 
 */
contract EthWallet is CpolloWallet {
 
    using SafeMath for uint256;
    /**
    * @dev Transfer eth to destination payed
    * @param payee The destination address of the funds.
    */
    function _transfer(address payee, uint256 amount) internal {
        _transfers[payee] = _transfers[payee].add(amount);
        payee.transfer(amount);
    }
    /**
    * @dev Transfer  funds back when scam happens.
    */
    function _transferFundsScam() internal {
        _teamWallet.transfer(address(this).balance);
    }

}