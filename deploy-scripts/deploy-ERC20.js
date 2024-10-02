const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying ERC20Token with account:", deployer.address);

    const ERC20Token = await ethers.getContractFactory("ERC20Token");
    const erc20 = await ERC20Token.deploy(deployer.address);
    await erc20.deployed();

    console.log("ERC20 deployed to:", erc20.address);
}

main()
    .then(() => {
        console.log("Deployment completed");
        process.exit(0);
    })
    .catch((error) => {
        console.error("Deployment failed:", error);
        process.exit(1);
    });
