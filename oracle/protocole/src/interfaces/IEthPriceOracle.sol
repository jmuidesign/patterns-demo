// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEthPriceOracle {
    event EthPriceSubmitted(address indexed submitter, uint256 indexed ethPrice);
    event EthPriceUpdated(uint256 indexed ethPrice, uint256 indexed lastUpdate);

    function submitEthPrice(uint256 _ethPrice) external;
    function updateEthPriceData() external;
    function getEthPriceData() external view returns (uint256 _ethPrice, uint256 _lastUpdate);
}
