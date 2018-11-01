const UserRole = artifacts.require('UserRole');
const CpolloRole = artifacts.require('CpolloRole');
const DevRole = artifacts.require('DevRole');
const LegaRole = artifacts.require('LegalRole');
const CpolloToken = artifacts.require('Cpollo');

var account0 = "0x6a7d1902eeed5e983e0d09cee98d0d69079c6bfd";
var account1 = "0xea01acd6c953965e8341d3d30664f77850726d76";
var account2 = "0xda5a0f71dbe314a893a8b595cc6be835e17f9c0d";
var account3 = "0xb526a1534a50b701c74b37b7fb3016b19e237780";
var account4 = "0xc0669a36d2af85b59b0fa74553baaaff4d55abc9";
var account5 = "0xf854e60e53306660f96ef83460f8e5cafed05d8d";


module.exports = function(callback) {
    console.log("starting");
    
    // perform actions
    async function deploy() {
        const cpollo = account0;
        const otherCpollo = account1;
        const dev = account3;
        const otherDev = account4;
        this.cpolloToken = await CpolloToken.new({ from: cpollo });
        console.log(this.cpolloToken.address);
        this.cpolloContract = await CpolloRole.new({ from: cpollo });
        await this.cpolloContract.addCpollo(otherCpollo , { from: cpollo});
        console.log(this.cpolloContract.address);
        this.devContract = await DevRole.new(this.cpolloContract.address, { from: cpollo });
        console.log(this.devContract.address);
        await this.devContract.addDev(otherDev, { from: cpollo });
        await this.devContract.addDev(dev, { from: cpollo });
        this.userContract = await userRole.new({ from: cpollo });
        console.log(this.userContract.address);
        await  this.userContract.addUser(otherCpollo, { from: cpollo });
        await  this.userContract.addUser(otherDev, { from: cpollo });
        await  this.userContract.addUser(dev, { from: cpollo });
    }

    async function run() {
        await deploy();
        callback();
    
    }
    run();
   
  }