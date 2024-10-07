const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC721Token", function () {
    let Token;
    let token;
    let owner;
    let buyer;
    let addr2;

    beforeEach(async function () {
        [owner, buyer, addr2] = await ethers.getSigners();

        Token = await ethers.getContractFactory("ERC721Token");
        token = await Token.deploy(owner.address);
        await token.deployed();
        await token.safeMint(owner.address, "https://token-uri.com");
        await token.setTokenPrice(0, ethers.utils.parseEther("1"));
    });

    describe("Token buy", function () {
        it("Should allow a user to buy an NFT", async function () {
            const price = ethers.utils.parseEther("1");

            await token.connect(buyer).buy(0, { value: price });

            expect(await token.ownerOf(0)).to.equal(buyer.address);
        });

        it("Should fail if the buyer sends less than the price", async function () {
            await expect(
                token.connect(buyer).buy(0, { value: ethers.utils.parseEther("0.5") })
            ).to.be.revertedWith("Not enough ETH");
        });

        it("Should fail if the token is not for sale", async function () {
            await token.setTokenPrice(0, 0);

            await expect(
                token.connect(buyer).buy(0, { value: ethers.utils.parseEther("1") })
            ).to.be.revertedWith("Required token not for sale");
        });

        it("Should fail if the buyer is the owner of the token", async function () {
            const price = ethers.utils.parseEther("1");

            await expect(
                token.connect(owner).buy(0, { value: price })
            ).to.be.revertedWith("Cannot buy your own NFT");
        });
    });
});
