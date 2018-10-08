// solium-disable linebreak-style
pragma solidity ^0.4.24;

import "../escrow/TokenEscrow.sol";
import "../escrow/CpolloEscrow.sol";
import "../escrow/LimitedEscrow.sol";
import "../escrow/DevRoleEscrow.sol";
import "../access/ICpolloRoles.sol";
import "../access/IDevRoles.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
/**
 * @title DevTokenEscrowMock
 * @dev Escrow that holds funds for development, only registered Devs are allowed to receive token funds,
 * when there are signals of Scam, Cpollo will freeze the funds to start auditing. If these signals are right, 
 * Cpollo will return funds to the team wallet.
 */
//contract DevTokenEscrowMock is TokenEscrow,  CpolloEscrow, LimitedEscrow, DevRoleEscrow, BaseEscrow {
contract DevTokenEscrowMock is  BaseEscrow {
    constructor(
        IDevRoles dev, 
        address manager
        )   
        BaseEscrow(manager) public {
            
    }



  /*  constructor(
        IDevRoles dev, 
        IERC20 token,
        uint256 amountLimit, 
        uint256 timestampInterval,
        address teamWallet, 
        ICpolloRoles cpollo,
        address manager
        )   
        TokenEscrow(token)
        CpolloEscrow(teamWallet,cpollo) 
        LimitedEscrow(amountLimit,timestampInterval)
        DevRoleEscrow(dev)
        BaseEscrow(manager) public {
            
    }*/

 
}
