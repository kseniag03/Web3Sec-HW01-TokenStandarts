// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155Token is ERC1155, Ownable {
    constructor(
        address initialOwner
    )
        ERC1155(
            "https://github.com/kseniag03/Web3Sec-HW01-TokenStandarts/blob/master/metadata/ERC1155Token.json"
        )
        Ownable(initialOwner)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

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
