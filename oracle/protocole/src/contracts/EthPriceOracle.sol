// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {IEthPriceOracle} from "../interfaces/IEthPriceOracle.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract EthPriceOracle is IEthPriceOracle, Ownable {
    uint256 public constant DECIMALS = 2;

    uint256 private ethPrice;
    uint256 private lastUpdate;
    uint256[] private ethPriceSubmissions;

    constructor() Ownable(msg.sender) {}

    function submitEthPrice(uint256 _ethPrice) external {
        ethPriceSubmissions.push(_ethPrice);

        emit EthPriceSubmitted(msg.sender, _ethPrice);
    }

    function updateEthPriceData() external onlyOwner {
        uint256 precision = 10 ** 18;
        // 10 ** 16 to convert from 18 decimals to 2 decimals
        uint256 precisionDenominator = 10 ** 16;

        uint256 ethPriceSubmissionsSum = 0;

        for (uint256 i = 0; i < ethPriceSubmissions.length; i++) {
            ethPriceSubmissionsSum += ethPriceSubmissions[i];
        }

        ethPrice = (ethPriceSubmissionsSum * precision / ethPriceSubmissions.length) / precisionDenominator;
        lastUpdate = block.timestamp;
        ethPriceSubmissions = new uint256[](0);

        emit EthPriceUpdated(ethPrice, lastUpdate);
    }

    function getEthPriceData() external view returns (uint256 _ethPrice, uint256 _lastUpdate) {
        return (ethPrice, lastUpdate);
    }
}
