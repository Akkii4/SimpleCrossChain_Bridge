// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol
    ) ERC20("CustomToken", "CTK") {}

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }
}
