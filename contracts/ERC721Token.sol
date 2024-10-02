// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Token is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    mapping(uint256 => uint256) public tokenPrices;

    constructor(
        address initialOwner
    ) ERC721("ERC721Token", "NFT") Ownable(initialOwner) {}

    function _baseURI() internal pure override returns (string memory) {
        return
            "https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/ERC721Token.json";
    }

    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setTokenPrice(uint256 tokenId, uint256 price) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the owner can set the price"
        );

        tokenPrices[tokenId] = price;
    }

    function buy(uint256 tokenId) public payable {
        require(msg.value > 0, "Need ETH to buy tokens");

        address owner = ownerOf(tokenId);
        uint256 price = tokenPrices[tokenId];

        require(price > 0, "Required token not for sale");
        require(owner != msg.sender, "Cannot buy your own NFT");
        require(msg.value >= price, "Not enough ETH");

        _transfer(owner, msg.sender, tokenId);

        payable(owner).transfer(price);
    }
}
