// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/access/roles/MinterRole.sol";
/**
 * @title Burnable token
 * @dev Burnable token with max supply
 * 
 */
contract BurnMintCapERC20Template is ERC20, ERC20Detailed, ERC20Burnable, ERC20Capped {
    using SafeERC20 for ERC20;

    constructor(
        string name,
        string symbol,
        uint8 decimals,
        address owner,
        uint256 cap
    )
        MinterRole()
        ERC20Capped(cap * (10 ** uint256(decimals)))
        ERC20Detailed(name, symbol, decimals)
        public
    {
    }
}
