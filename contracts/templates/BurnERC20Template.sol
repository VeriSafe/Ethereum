// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title Burnable ERC20 token
 * @dev Burnable ERC20 token with max supply and owner provided
 * 
 */
contract BurnERC20Template is ERC20, ERC20Detailed, ERC20Burnable {
    using SafeERC20 for ERC20;

    constructor(
        string name,
        string symbol,
        uint8 decimals,
        address owner,
        uint256 supply
    )
        ERC20Detailed(name, symbol, decimals)
        public
    {
        _mint(owner, supply * (10 ** uint256(decimals)));
    }
}
