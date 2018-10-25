// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/access/roles/MinterRole.sol";

/**
 * @title Burnable and Mintable token template
 * @dev Burnable and Mintable token with max supply and owner provided
 * 
 */
contract BurnMintTokenTemplate is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable {
    using SafeERC20 for ERC20;

    constructor(
        string name,
        string symbol,
        uint8 decimals,
        address owner,
        uint256 supply,
        uint256 cap
    )
        MinterRole()
        ERC20Detailed(name, symbol, decimals)
        public
    {
        _mint(owner, supply * (10 ** uint256(decimals)));
    }
}
