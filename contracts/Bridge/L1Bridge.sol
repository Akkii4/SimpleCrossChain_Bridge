// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Layer1Bridge {
    IERC20 private tokenL1;

    address public crossChainValidators;

    event TokensLocked(
        address indexed requester,
        bytes32 indexed layer1DepositHash,
        uint amount,
        uint timestamp
    );

    event TokensUnlocked(
        address indexed requester,
        bytes32 indexed sideDepositHash,
        uint amount,
        uint timestamp
    );

    modifier onlyCrossChainValidators() {
        require(
            msg.sender == crossChainValidators,
            "only crossChainValidators can execute this function"
        );
        _;
    }

    constructor(address _tokenL1, address _gateway) {
        tokenL1 = IERC20(_tokenL1);
        crossChainValidators = _gateway;
    }

    function lockTokens(
        address _receiver,
        uint _bridgedAmount,
        bytes32 _layer1DepositHash
    ) external onlyCrossChainValidators {
        tokenL1.transferFrom(msg.sender, _receiver, _bridgedAmount);
        emit TokensLocked(
            _receiver,
            _layer1DepositHash,
            _bridgedAmount,
            block.timestamp
        );
    }

    function unlockTokens(
        address _receiver,
        uint _bridgedAmount,
        bytes32 _layer2DepositHash
    ) external onlyCrossChainValidators {
        tokenL1.transfer(_receiver, _bridgedAmount);
        emit TokensUnlocked(
            _receiver,
            _layer2DepositHash,
            _bridgedAmount,
            block.timestamp
        );
    }
}
