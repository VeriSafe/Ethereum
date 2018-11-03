// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";

/**
 * @title Cpollo Token template used in testnet
 * @dev 
 * 
 */
contract Cpollo is ERC20, ERC20Detailed, ERC20Burnable {
    using SafeERC20 for ERC20;

    constructor(
        string name,
        string symbol,
        uint8 decimals
    )
        ERC20Burnable()
        ERC20Detailed(name, symbol, decimals)
        ERC20()
        public
    {
        _mint(0x6a7d1902eeed5e983e0d09cee98d0d69079c6bfd, 20000000000 * (10 ** uint256(decimals)));
    }
}
