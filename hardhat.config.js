require('dotenv').config();
require("@nomiclabs/hardhat-waffle");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_ID}`,
      accounts: [`0x${process.env.METAMASK_PRIVATE_KEY}`]
    }
  },
  solidity: "0.8.27",
};
