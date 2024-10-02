const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying ERC721Token with account:", deployer.address);

    const ERC721Token = await ethers.getContractFactory("ERC721Token", deployer);
    const erc721 = await ERC721Token.deploy(deployer.address);
    await erc721.deployed();

    console.log("ERC721 deployed to:", erc721.address);
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
