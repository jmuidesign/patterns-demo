// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {IEthPriceOracle} from "../interfaces/IEthPriceOracle.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract EthPriceOracle is IEthPriceOracle, AccessControl {
    uint256 public constant DECIMALS = 2;
    uint256 public constant MAX_SUBMISSIONS = 100;
    bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");

    uint256 private ethPrice;
    uint256 private lastUpdate;
    uint256[] private ethPriceSubmissions;

    constructor() AccessControl() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function submitEthPrice(uint256 _ethPrice) external onlyRole(PROVIDER_ROLE) {
        ethPriceSubmissions.push(_ethPrice);

        emit EthPriceSubmitted(msg.sender, _ethPrice);

        if (ethPriceSubmissions.length == MAX_SUBMISSIONS) _updateEthPriceData();
    }

    function getEthPriceData() external view returns (uint256 _ethPrice, uint256 _lastUpdate) {
        return (ethPrice, lastUpdate);
    }

    function _updateEthPriceData() private {
        uint256 ethPriceSubmissionsSum = 0;

        for (uint256 i = 0; i < ethPriceSubmissions.length; i++) {
            ethPriceSubmissionsSum += ethPriceSubmissions[i];
        }

        ethPrice = ethPriceSubmissionsSum / ethPriceSubmissions.length;
        lastUpdate = block.timestamp;
        ethPriceSubmissions = new uint256[](0);

        emit EthPriceUpdated(ethPrice, lastUpdate);
    }
}
