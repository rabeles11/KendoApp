const Migrations = artifacts.require("KendoApp");

module.exports = function(deployer) {
    deployer.deploy(Migrations);
};