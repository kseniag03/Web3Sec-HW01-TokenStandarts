// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20Token is ERC20, Ownable, ERC20Permit {
    constructor(
        address initialOwner
    )
        ERC20("ERC20Token", "MTK")
        Ownable(initialOwner)
        ERC20Permit("ERC20Token")
    {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function buy(uint256 amount) public payable {
        require(msg.value > 0, "Need ETH to buy tokens");
        require(amount > 0, "Required amount must be positive");

        uint256 tokenPrice = 0.01 ether;
        uint256 totalCost = tokenPrice * amount;

        require(msg.value >= totalCost, "Not enough ETH");

        _mint(msg.sender, amount);

        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }
}
