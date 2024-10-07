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

## Deploy
```bash
npx hardhat run deploy-scripts/deploy-ERC20.js --network sepolia
npx hardhat run deploy-scripts/deploy-ERC721.js --network sepolia
npx hardhat run deploy-scripts/deploy-ERC1155.js --network sepolia
```

## Contract Links
WANTED

## Questions
1. ```approve``` позволяет владельцу токена разрешить 3-й стороне (адресу или контракту) управлять определенным кол-вом токенов (использовать transferFrom для перевода от владельца к другому адресу)
2. ERC721: уникальные и невзаимозаменяемые токены; ERC1155: многофункциональные токены (можно создавать и взаимозаменяемые, и уникальные в рамках одного контракта)
3. Soulbound-токен (SBT) — непередаваемый токен, разновидность NFT-актива, который выпускается в единственном экземпляре, а доступ к нему имеет только владелец адреса
4. Можно создать SBT токен, добавив ограничения на передачу в контракты ERC721 или ERC1155