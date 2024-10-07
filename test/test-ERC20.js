const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ERC20Token", function () {
    let Token;
    let token;
    let owner;
    let buyer;
    let addr1;
    let addr2;
    let feeCollector;
    const initialSupply = ethers.utils.parseEther("1000");
    const feePercent = 1;

    beforeEach(async function () {
        [owner, buyer, addr1, addr2, feeCollector] = await ethers.getSigners();

        Token = await ethers.getContractFactory("ERC20Token");
        token = await Token.deploy(owner.address, feeCollector.address, feePercent);
        await token.deployed();
        await token.mint(owner.address, initialSupply);
    });

    describe("Token buy", function () {
        it("Should allow a user to buy a specific amount of tokens", async function () {
            const amount = 100;
            const price = ethers.utils.parseEther("1");

            await token.connect(buyer).buy(amount, { value: price });

            const balance = await token.balanceOf(buyer.address);

            expect(balance).to.equal(amount);
        });

        it("Should fail if the buyer sends less than the required ETH", async function () {
            const amount = 100;
            const price = ethers.utils.parseEther("0.5");

            await expect(
                token.connect(buyer).buy(amount, { value: price })
            ).to.be.revertedWith("Not enough ETH");
        });

        it("Should refund excess ETH sent by the buyer", async function () {
            const amount = 100;
            const price = ethers.utils.parseEther("1");
            const initialBalance = await ethers.provider.getBalance(buyer.address);
            const tx = await token.connect(buyer).buy(amount, {
                value: ethers.utils.parseEther("2"),
            });
            const receipt = await tx.wait();
            const gasUsed = receipt.gasUsed.mul(receipt.effectiveGasPrice);
            const finalBalance = await ethers.provider.getBalance(buyer.address);
            const expectedFinalBalance = initialBalance.sub(price).sub(gasUsed);

            expect(finalBalance).to.equal(expectedFinalBalance);
        });

        it("Should fail if the buyer sends zero ETH", async function () {
            const amount = 100;

            await expect(
                token.connect(buyer).buy(amount, { value: 0 })
            ).to.be.revertedWith("Need ETH to buy tokens");
        });
    });

    describe("Token transfer with fee", function () {
        it("Should transfer tokens with a fee", async function () {
            const amount = ethers.utils.parseEther("20");
            const fee = amount.mul(feePercent).div(100);
            const amountAfterFee = amount.sub(fee);
            const balance = await token.balanceOf(owner.address);

            await token.transfer(addr1.address, amount);

            expect(await token.balanceOf(addr1.address)).to.equal(amountAfterFee);
            expect(await token.balanceOf(owner.address)).to.equal(balance.sub(amount));
            expect(await token.balanceOf(feeCollector.address)).to.equal(fee);
        });

        it("Should allow transferFrom with a fee", async function () {
            const amount = ethers.utils.parseEther("20");
            const fee = amount.mul(feePercent).div(100);
            const amountAfterFee = amount.sub(fee);

            await token.mint(addr1.address, initialSupply);
            await token.connect(owner).approve(addr1.address, amount);

            expect(await token.allowance(owner.address, addr1.address)).to.equal(amount);

            await token.connect(addr1).transferFrom(owner.address, addr2.address, amount);

            expect(await token.balanceOf(addr1.address)).to.equal(initialSupply);
            expect(await token.balanceOf(owner.address)).to.equal(initialSupply.sub(amount));
            expect(await token.balanceOf(addr2.address)).to.equal(amountAfterFee);
            expect(await token.balanceOf(feeCollector.address)).to.equal(fee);
        });

        it("Should revert if allowance is exceeded", async function () {
            const amount = ethers.utils.parseEther("20");
            const insufficientAmount = ethers.utils.parseEther("25");

            await token.mint(addr1.address, initialSupply);
            await token.connect(owner).approve(addr1.address, amount.sub(1));

            expect(await token.allowance(owner.address, addr1.address)).to.equal(amount.sub(1));

            await expect(
                token.connect(addr1).transferFrom(owner.address, addr2.address, insufficientAmount)
            ).to.be.revertedWith("Allowance exceeded");
        });
    });

    describe("Permit", function () {
        it("Should allow gasless transfers with Permit", async function () {
            const domain = {
                name: "ERC20Token",
                version: "1",
                chainId: 1337,
                verifyingContract: token.address,
            };
            const types = {
                Permit: [
                    { name: "owner", type: "address" },
                    { name: "spender", type: "address" },
                    { name: "value", type: "uint256" },
                    { name: "nonce", type: "uint256" },
                    { name: "deadline", type: "uint256" },
                ],
            };
            const deadline = Math.floor(Date.now() / 1000) + 60 * 60;
            const nonce = await token.nonces(owner.address);
            const value = ethers.utils.parseEther("10");
            const signature = await owner._signTypedData(domain, types, {
                owner: owner.address,
                spender: addr1.address,
                value: value,
                nonce: nonce,
                deadline: deadline,
            });
            const { v, r, s } = ethers.utils.splitSignature(signature);

            await token.permit(owner.address, addr1.address, value, deadline, v, r, s);

            expect(await token.allowance(owner.address, addr1.address)).to.equal(value);
        });
    });
});
