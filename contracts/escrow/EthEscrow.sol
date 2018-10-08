// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./LimitedEscrow.sol";
import "./CpolloEscrow.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title EthEscrow
 * @dev Base escrow contract that holds token funds destinated to a role. 
 * Only Escrow managers can transfer funds
 * 
 */
contract EthEscrow is CpolloEscrow {
 
    using SafeMath for uint256;
     /**
    * @dev Transfer Assets to destination payed
    * @param payee The destination address of the funds.
    */
    function transfer(address payee, uint256 amount) public payable {
        _preTransfer(payee, amount);
        require(_escrowManager.has(msg.sender), "You must be a Escrow Manager");
        _transfer(payee, amount);
        emit Transfered(payee, msg.sender, amount);
    }

    /**
    * @dev Transfer tokens to destination payed
    * @param payee The destination address of the funds.
    */
    function _transfer(address payee, uint256 amount) internal {
        _transfer[payee] = _transfers[payee].add(amount);
        payee.transfer(amount);
    }
    /**
    * @dev Transfer  funds back when scam happens.
    */
    function _transferFundsScam() internal {
        _teamWallet.tranfer(this.balance);
    }

}