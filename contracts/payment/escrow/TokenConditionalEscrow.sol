pragma solidity ^0.4.24;

import "./TokenEscrow.sol";

/**
 * @title TokenConditionalEscrow
 * @dev Base abstract token escrow to only allow withdrawal if a condition is met.
 */
contract TokenConditionalEscrow is TokenEscrow {
    /**
    * @dev Returns whether an address is allowed to withdraw their funds. To be
    * implemented by derived contracts.
    * @param payee The destination address of the funds.
    */
    function withdrawalAllowed(address payee) public view returns (bool);

    function withdraw(address payee) public {
        require(withdrawalAllowed(payee));
        super.withdraw(payee);
    }
}
