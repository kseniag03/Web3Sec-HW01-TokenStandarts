// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract ERC20Token is ERC20, Ownable, ERC20Permit {
    address public feeCollector;
    uint256 public feePercent;

    /**
     * @dev Sets the initial owner for the contract and calls the ERC20 constructor.
     * @param initialOwner The address of the initial owner of the token.
     * @param _feeCollector The address that will collect fees from transfers.
     * @param _feePercent The percentage of the transfer amount to be taken as a fee.
     */
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

    /**
     * @dev Mints a specified amount of tokens to a given address.
     * @param to The address that will receive minted token.
     * @param amount The number of tokens to mint.
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    /**
     * @dev Allows users to buy tokens using ETH.
     * If the user sends more ETH than required, the difference is refunded.
     * @param amount The number of tokens to buy.
     */
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

    /**
     * @dev Transfers tokens to a specified address and collects a fee.
     * @param recipient The address of the recipient.
     * @param amount The amount of tokens to transfer.
     * @return bool Indicates whether the transfer was successful.
     */
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
        require(fee >= 0, "Fee calculation error");

        super.transfer(feeCollector, fee);
        super.transfer(recipient, amountFee);

        return true;
    }

    /**
     * @dev Transfers tokens from one address to another and collects a fee.
     * @param sender The address of the sender.
     * @param recipient The address of the recipient.
     * @param amount The amount of tokens to transfer.
     * @return bool Indicates whether the transfer was successful.
     */
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
