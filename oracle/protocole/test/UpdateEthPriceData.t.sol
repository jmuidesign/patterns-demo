// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BaseTest} from "./helpers/Base.sol";
import {IEthPriceOracle} from "../src/interfaces/IEthPriceOracle.sol";

contract UpdateEthPriceDataTest is BaseTest {
    function setUp() public override {
        super.setUp();
    }

    function test_updateEthPriceData_succeeds() public {
        _setEthPriceSubmissionsLengthToMaxSubmissions();

        (uint256 ethPrice, uint256 lastUpdate) = oracle.getEthPriceData();

        assertEq(ethPrice, _getEthPriceExpected());
        assertEq(lastUpdate, block.timestamp);
        assertEq(_getEthPriceSubmissionsLength(), 0);
    }

    function test_updateEthPriceData_emitsEthPriceUpdated() public {
        _setEthPriceSubmissionsLengthToMaxSubmissionsMinusOne();

        vm.expectEmit();
        emit IEthPriceOracle.EthPriceUpdated(_getEthPriceExpected(), block.timestamp);

        vm.prank(user2);
        oracle.submitEthPrice(ethSubmission2);
    }
}
