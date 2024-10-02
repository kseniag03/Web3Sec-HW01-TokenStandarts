// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20Token is ERC20, Ownable, ERC20Permit {
    address public feeCollector;
    uint256 public feePercent;

    constructor(
        address initialOwner,
        address _feeCollector,
        uint256 _feePercent
    )
        ERC20("ERC20Token", "MTK")
        Ownable(initialOwner)
        ERC20Permit("ERC20Token")
    {
        feeCollector = _feeCollector;
        feePercent = _feePercent;
    }

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

    function transfer(
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        uint256 fee = (amount * feePercent) / 100;
        uint256 amountFee = amount - fee;

        require(
            balanceOf(msg.sender) >= amount,
            "Insufficient funds on balance"
        );

        super.transfer(feeCollector, fee);
        super.transfer(recipient, amountFee);

        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        uint256 fee = (amount * feePercent) / 100;
        uint256 amountFee = amount - fee;

        require(balanceOf(sender) >= amount, "Insufficient funds on balance");
        require(allowance(sender, msg.sender) >= amount, "Allowance exceeded");

        super.transferFrom(sender, feeCollector, fee);
        super.transferFrom(sender, recipient, amountFee);

        return true;
    }
}
