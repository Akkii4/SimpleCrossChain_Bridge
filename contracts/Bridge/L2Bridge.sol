// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICustomTokenL2 {
    function mint(address recipient, uint256 amount) external;

    function burn(uint256 amount) external;

    function burnFrom(address account, uint256 amount) external;
}

import "@openzeppelin/contracts/access/Ownable.sol";

contract L2Bridge is Ownable {
    event BridgeInitialized(uint indexed timestamp);
    event TokensBridged(
        address indexed receiver,
        bytes32 indexed layer1DepositHash,
        uint amount,
        uint timestamp
    );
    event TokensReturned(
        address indexed receiver,
        bytes32 indexed layer2DepositHash,
        uint amount,
        uint timestamp
    );

    ICustomTokenL2 private tokenL2;
    bool public bridgeInitialized;
    address public crossChainValidator;

    modifier isBridgeInitialized() {
        require(bridgeInitialized, "Bridge has not been initialized");
        _;
    }

    modifier onlyCrossChainValidators() {
        require(
            msg.sender == crossChainValidator,
            "Only crossChainValidator can execute this function"
        );
        _;
    }

    constructor(address _crossChainValidator) {
        crossChainValidator = _crossChainValidator;
    }

    function initializeBridge(address _l2Token) external onlyOwner {
        tokenL2 = ICustomTokenL2(_l2Token);
        bridgeInitialized = true;
    }

    function bridgeTokens(
        address _receiver,
        uint _bridgedAmount,
        bytes32 _layer1DepositHash
    ) external isBridgeInitialized onlyCrossChainValidators {
        tokenL2.mint(_receiver, _bridgedAmount);
        emit TokensBridged(
            _receiver,
            _layer1DepositHash,
            _bridgedAmount,
            block.timestamp
        );
    }

    function returnTokens(
        address _receiver,
        uint _bridgedAmount,
        bytes32 _layer2DepositHash
    ) external isBridgeInitialized onlyCrossChainValidators {
        tokenL2.burn(_bridgedAmount);
        emit TokensReturned(
            _receiver,
            _layer2DepositHash,
            _bridgedAmount,
            block.timestamp
        );
    }
}
