require('dotenv').config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_ID}`,
      accounts: [`${process.env.METAMASK_PRIVATE_KEY}`]
    }
  },
  solidity: "0.8.27",
};
