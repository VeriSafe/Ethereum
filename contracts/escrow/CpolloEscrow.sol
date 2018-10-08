// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "./BaseEscrow.sol";
import "../access/ICpolloRoles.sol";
/**
 * @title CpolloEscrow
 * @dev Cpollo Escrow holds all the logic to manage and avoid scams in projects escrows 
 */
contract CpolloEscrow is BaseEscrow {
    enum State { Active, Freeze, Scam }

    event ScamAlert(address indexed account);
    event FreezeAlert(address indexed account);
    event unFreezeAlert(address indexed account);

    ICpolloRoles _cpollo;
    State private _state;
    address internal _teamWallet;

    constructor(address teamWallet, ICpolloRoles cpollo) {
        require(teamWallet != address(0), "Team Wallet can not be 0");
        _state = State.Active;
        _teamWallet = teamWallet;
        _cpollo = cpollo;
    }

    modifier onlyCpollo() {
        require(_cpollo.isCpollo(msg.sender), "Only Cpollo Members allowed");
        _;
    }
    /**
    * @return the current state of the escrow.
    */
    function state() public view returns (State) {
        return _state;
    }

    /**
    * @return the team wallet where the funds will return when Scam happens
    */
    function refundWallet() public view returns (address) {
        return _teamWallet;
    }

    /**
    * @dev Scam noticed by CPollo company, return all the funds to the team wallet
    */
    function scamAlert() public onlyCpollo {
        _state = State.Scam;
        _transferFundsScam();
        emit ScamAlert(msg.sender);
    }
    /**
    * @dev Freeze escrow for Cpollo start investigate.
    */
    function freeze() public onlyCpollo {
        _state = State.Freeze;
        emit FreezeAlert(msg.sender);
    } 
     /**
    * @dev UnFreeze escrow when investigation finish.
    */
    function unFreeze() public onlyCpollo {
        _state = State.Active;
        emit unFreezeAlert(msg.sender);
    } 

    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_state == State.Active, "Escrow must be active");
    }

      /**
    * @dev Must Override. Where the funds are transfered when Scam happens.
    */
    function _transferFundsScam() internal;

}
