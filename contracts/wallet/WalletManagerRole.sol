// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/access/Roles.sol";

import "./BaseWallet.sol";


contract WalletManagerRole is BaseWallet {
    using Roles for Roles.Role;

    event WalletManagerAdded(address indexed account);
    event WalletManagerRemoved(address indexed account);

    Roles.Role internal _walletManager;

    constructor(address manager) public {
        _addWalletManager(manager);
    }

    modifier onlyWalletManager() {
        require(isWalletManager(msg.sender), "Only WalletManager Members allowed");
        _;
    }

    function isWalletManager(address account) public view returns (bool) {
        return _walletManager.has(account);
    }

    function addWalletManager(address account) public onlyWalletManager {
        _addWalletManager(account);
    }

    function renounceWalletManager() public {
        _removeWalletManager(msg.sender);
    }

    function _addWalletManager(address account) internal {
        _walletManager.add(account);
        emit WalletManagerAdded(account);
    }
    /**
    * @dev Can be overriden. The overriding function
    * should call super._removeWalletManager(account) to ensure the chain of transfer is
    * executed entirely.
   */
    function _removeWalletManager(address account) internal {
        _walletManager.remove(account);
        emit WalletManagerRemoved(account);
    }
     /**
   * @dev Can be overridden to add pre transfer logic. The overriding function
   * should call super._preTransfer(payed, amount) to ensure the chain of transfer is
   * executed entirely.
   */
    function _preTransfer(address payee, uint256 amount) internal {
        super._preTransfer(payee, amount);
        require(_walletManager.has(msg.sender), "You must be a Wallet Manager to do transfers in this Wallet");      
    }



}