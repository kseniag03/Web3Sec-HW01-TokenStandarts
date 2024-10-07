// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155Token is ERC1155, Ownable {
    /**
     * @dev Sets the initial owner for the contract and calls the ERC1155 constructor with the metadata URI.
     * @param initialOwner The address of the initial owner of the token.
     */
    constructor(
        address initialOwner
    )
        ERC1155(
            "https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/ERC1155Token.json"
        )
        Ownable(initialOwner)
    {}

    /**
     * @dev Sets a new URI for all tokens.
     * @notice Only the owner of the contract can call this function.
     * @param newuri The new metadata URI for the tokens.
     */
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /**
     * @dev Mints a new ERC1155 token.
     * @notice Only the owner of the contract can mint new tokens.
     * @param account The address that will receive minted tokens.
     * @param id The token ID.
     * @param amount The number of tokens to mint.
     * @param data Additional data with no specified format.
     */
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    /**
     * @dev Mints multiple tokens in a batch.
     * @notice Only the owner of the contract can call this function.
     * @param to The address that will receive the batch of tokens.
     * @param ids The array of token IDs.
     * @param amounts The array of token amounts to mint.
     * @param data Additional data with no specified format.
     */
    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    /**
     * @dev Mints the token to the buyer's address after receiving the payment.
     * If the user sends more ETH than required, the difference is refunded.
     * @param id The token ID to buy.
     * @param amount The number of tokens to buy.
     */
    function buy(uint256 id, uint256 amount) public payable {
        require(msg.value > 0, "Need ETH to buy tokens");
        require(amount > 0, "Required amount must be positive");

        uint256 tokenPrice = 0.01 ether;
        uint256 totalCost = tokenPrice * amount;

        require(msg.value >= totalCost, "Not enough ETH");

        _mint(msg.sender, id, amount, "");

        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }
}
