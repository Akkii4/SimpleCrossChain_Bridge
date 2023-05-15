// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract CustomToken is ERC20, ERC20Burnable {
    address public bridgeL2;

    modifier onlyBridge() {
        require(msg.sender == bridgeL2, "Only Bridge access allowed");
        _;
    }

    constructor(address _bridgeL2) ERC20("CustomTokenChild", "CTK") {
        bridgeL2 = _bridgeL2;
    }

    function mint(address recipient, uint256 amount) public virtual onlyBridge {
        _mint(recipient, amount);
    }

    function burn(
        uint256 amount
    ) public virtual override(ERC20Burnable) onlyBridge {
        super.burn(amount);
    }

    function burnFrom(
        address account,
        uint256 amount
    ) public virtual override(ERC20Burnable) onlyBridge {
        super.burnFrom(account, amount);
    }
}
