const { ethers } = require("hardhat");

async function main() {
    const [deployer, addr1, addr2] = await ethers.getSigners();

    console.log("Deploying ERC721Token with account:", deployer.address);

    const ERC721Token = await ethers.getContractFactory("ERC721Token", deployer);
    const erc721 = await ERC721Token.deploy(deployer.address);

    await erc721.deployed();

    console.log("ERC721 deployed to:", erc721.address);

    const contract = await ERC721Token.attach(erc721.address);

    await contract.safeMint(deployer.address, "https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/ERC721Token.json");
    await contract.setTokenPrice(0, ethers.utils.parseEther("0.001"));
    await contract.approve(addr1.address, 0);
    await contract.connect(addr1).safeTransferFrom(deployer.address, addr1.address, 0);

}

main()
    .then(() => {
        console.log("Deployment and interaction completed");
        process.exit(0);
    })
    .catch((error) => {
        console.error("Deployment failed:", error);
        process.exit(1);
    });
