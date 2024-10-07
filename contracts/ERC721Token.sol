// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Token is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    /// @dev Prices are stored as uint256 values where the key is the tokenId.
    mapping(uint256 => uint256) public tokenPrices;

    /**
     * @dev Sets the initial owner for the contract and calls the ERC721 constructor.
     * @param initialOwner The address of the initial owner of the token.
     */
    constructor(
        address initialOwner
    ) ERC721("ERC721Token", "NFT") Ownable(initialOwner) {}

    /**
     * @dev Returns the base URI for all tokens.
     * @return A string representing the base URI.
     */
    function _baseURI() internal pure override returns (string memory) {
        return
            "https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/ERC721Token.json";
    }

    /**
     * @dev Mints a new token to the specified address with a given URI.
     * @notice Only the owner can call this function. The tokenId is auto-incremented.
     * @param to The address that will receive minted token.
     * @param uri The URI associated with the token metadata.
     */
    function safeMint(address to, string memory uri) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    /**
     * @dev Returns the URI for a given tokenId.
     * @param tokenId The token ID for which to fetch the URI.
     * @return The string representing the token's metadata URI.
     */
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /**
     * @dev Checks if the contract supports a specific interface.
     * @param interfaceId The interface ID.
     * @return True if the contract supports the requested interface, otherwise false.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @dev Sets the price for a specific token.
     * @notice Only the owner of the contract can call this function.
     * @param tokenId The ID of the token to set the price for.
     * @param price The price in Wei for which the token can be bought.
     */
    function setTokenPrice(uint256 tokenId, uint256 price) public onlyOwner {
        tokenPrices[tokenId] = price;
    }

    /**
     * @dev Allows users to buy token using ETH.
     * The token must have a price set and be owned by someone other than the buyer.
     * @param tokenId The token ID to buy.
     */
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
