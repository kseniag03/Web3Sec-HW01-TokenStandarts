const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC1155Token", function () {
    let Token;
    let token;
    let owner;
    let buyer;
    let addr1;

    beforeEach(async function () {
        [owner, buyer, addr1] = await ethers.getSigners();

        Token = await ethers.getContractFactory("ERC1155Token");
        token = await Token.deploy(owner.address);
        await token.deployed();
    });

    describe("Token buy", function () {
        it("Should allow a user to buy a specific amount of tokens", async function () {
            const tokenId = 1;
            const amount = 10;
            const price = ethers.utils.parseEther("0.1");

            await token.connect(buyer).buy(tokenId, amount, { value: price });

            expect(await token.balanceOf(buyer.address, tokenId)).to.equal(amount);
        });

        it("Should fail if the buyer sends less than the required ETH", async function () {
            const tokenId = 1;
            const amount = 10;
            const price = ethers.utils.parseEther("0.05");

            await expect(
                token.connect(buyer).buy(tokenId, amount, { value: price })
            ).to.be.revertedWith("Not enough ETH");
        });

        it("Should refund excess ETH sent by the buyer", async function () {
            const tokenId = 1;
            const amount = 10;
            const price = ethers.utils.parseEther("0.1");
            const initialBalance = await ethers.provider.getBalance(buyer.address);
            const transaction = await token.connect(buyer).buy(tokenId, amount, {
                value: ethers.utils.parseEther("0.2"),
            });
            const receipt = await transaction.wait();
            const expectedFinalBalance = initialBalance.sub(price).sub(receipt.gasUsed.mul(receipt.effectiveGasPrice));

            expect(await ethers.provider.getBalance(buyer.address)).to.equal(expectedFinalBalance);
        });
    });
});
