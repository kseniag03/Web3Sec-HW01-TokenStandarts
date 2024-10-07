# Web3Sec-HW01-TokenStandarts

## Tools
- Dotenv
- Hardhat
- Infura
- Metamask
- OpenZeppelin

## Install
```bash
npm install
```

## Testing
```bash
npx hardhat node
npx hardhat test
```

## Deploy with local hardhat test network
```bash
npx hardhat run deploy-scripts/deploy-ERC20.js --network hardhat
npx hardhat run deploy-scripts/deploy-ERC721.js --network hardhat
npx hardhat run deploy-scripts/deploy-ERC1155.js --network hardhat
```

## Deploy ERC721
```bash
npx hardhat run deploy-scripts/deploy-ERC721.js --network amoy/sepolia
```
Далее в строке вывода: "ERC721 deployed to:" получить адрес и ввести его при импорте токена в Metamask:
![скрин из кошелька](https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/721-nft-metamask.jpg)
![скрин из кошелька](https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/721-nft-metamask-sepolia.jpg)

## Contract Links
1. ERC721 Sepolia: https://sepolia.etherscan.io/address/0x842ac4Af042ffa0Baa62A350E70d5e10cC3C25BB
2. ERC721 Amoy: https://www.oklink.com/ru/amoy/address/0x012b49DA86842972080248455BbF62f5008c5964

## Questions
1. ```approve``` позволяет владельцу токена разрешить 3-й стороне (адресу или контракту) управлять определенным кол-вом токенов (использовать transferFrom для перевода от владельца к другому адресу)
2. ERC721: уникальные и невзаимозаменяемые токены; ERC1155: многофункциональные токены (можно создавать и взаимозаменяемые, и уникальные в рамках одного контракта)
3. Soulbound-токен (SBT) — непередаваемый токен, разновидность NFT-актива, который выпускается в единственном экземпляре, а доступ к нему имеет только владелец адреса
4. Можно создать SBT токен, добавив ограничения на передачу в контракты ERC721 или ERC1155