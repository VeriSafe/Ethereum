var Migrations = artifacts.require("Migrations");
const UserRole = artifacts.require('UserRole');
const CpolloRole = artifacts.require('CpolloRole');
const DevRole = artifacts.require('DevRole');
const LegalRole = artifacts.require('LegalRole');
const ManagerRole = artifacts.require('ManagerRole');
const MarketingRole = artifacts.require('MarketingRole');
const CpolloToken = artifacts.require('Cpollo');
const DevTokenEscrowTemplate = artifacts.require('DevTokenEscrowTemplate');
/**
 * Migrations for testnet
 */
module.exports = async function(deployer) {
  // Deploy the Migrations contract as our only task
 await deployer.deploy(CpolloToken, 'Cpollo', 'CPLO', '18');
 await deployer.deploy(CpolloRole);
 await deployer.deploy(DevRole, 0x47bf3635e181a8faf722b543431de18f6e2347b5);
 await deployer.deploy(UserRole, 0x47bf3635e181a8faf722b543431de18f6e2347b5);
 await deployer.deploy(LegalRole, 0x47bf3635e181a8faf722b543431de18f6e2347b5);
 await deployer.deploy(ManagerRole, 0x47bf3635e181a8faf722b543431de18f6e2347b5);
 await deployer.deploy(MarketingRole, 0x47bf3635e181a8faf722b543431de18f6e2347b5);
 await deployer.deploy(DevTokenEscrowTemplate,
                            DevRole.address,
                            CpolloToken.address,
                            100000000000000000000, //10^20
                            5348682895, // one month
                            0xc0669a36d2af85b59b0fa74553baaaff4d55abc9,
                            0x47bf3635e181a8faf722b543431de18f6e2347b5,
                            0x6a7d1902eeed5e983e0d09cee98d0d69079c6bfd
                            );
};