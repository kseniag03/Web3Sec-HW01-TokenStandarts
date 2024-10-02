const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying ERC1155Token with account:", deployer.address);

    const ERC1155Token = await ethers.getContractFactory("ERC1155Token");
    const erc1155 = await ERC1155Token.deploy(deployer.address);
    await erc1155.deployed();

    console.log("ERC1155Token deployed to:", erc1155.address);
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
