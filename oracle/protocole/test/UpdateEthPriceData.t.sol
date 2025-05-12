// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {EthPriceOracle} from "../src/contracts/EthPriceOracle.sol";
import {IEthPriceOracle} from "../src/interfaces/IEthPriceOracle.sol";

contract UpdateEthPriceDataTest is Test {
    address public user1;
    address public user2;

    uint256 public ethSubmission1;
    uint256 public ethSubmission2;
    uint256 public ethSubmission3;

    EthPriceOracle public oracle;

    function setUp() public {
        user1 = address(1);
        user2 = address(2);

        ethSubmission1 = 1000;
        ethSubmission2 = 1001;
        ethSubmission3 = 999;

        oracle = new EthPriceOracle();
    }

    function test_updateEthPriceData_succeeds() public {
        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);

        vm.prank(user2);
        oracle.submitEthPrice(ethSubmission2);

        oracle.updateEthPriceData();

        (uint256 ethPrice, uint256 lastUpdate) = oracle.getEthPriceData();

        assertEq(ethPrice, _getEthPriceExpected());
        assertEq(lastUpdate, block.timestamp);
        assertEq(_getEthPriceSubmissionsLength(), 0);
    }

    function test_updateEthPriceData_emitsEthPriceUpdated() public {
        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);

        vm.prank(user2);
        oracle.submitEthPrice(ethSubmission2);

        vm.expectEmit();
        emit IEthPriceOracle.EthPriceUpdated(_getEthPriceExpected(), block.timestamp);

        oracle.updateEthPriceData();
    }

    function _getEthPriceExpected() internal view returns (uint256) {
        uint256 precision = 10 ** 18;
        uint256 precisionDenominator = 10 ** 16;

        return ((ethSubmission1 + ethSubmission2) * precision / 2) / precisionDenominator;
    }

    function _getEthPriceSubmissionsLength() internal view returns (uint256 length) {
        bytes32 lengthSlot = keccak256(abi.encode(3));

        return uint256(vm.load(address(oracle), lengthSlot));
    }
}
