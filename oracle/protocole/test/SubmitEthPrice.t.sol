// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {BaseTest} from "./helpers/Base.sol";
import {IEthPriceOracle} from "../src/interfaces/IEthPriceOracle.sol";

contract SubmitEthPriceTest is BaseTest {
    function setUp() public override {
        super.setUp();
    }

    function test_submitEthPrice_succeeds() public {
        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);

        assertEq(_getEthPriceSubmissionByIndex(0), ethSubmission1);
    }

    function test_submitEthPrice_succeedsMultipleTimes() public {
        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);

        vm.prank(user2);
        oracle.submitEthPrice(ethSubmission2);

        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission3);

        assertEq(_getEthPriceSubmissionByIndex(0), ethSubmission1);
        assertEq(_getEthPriceSubmissionByIndex(1), ethSubmission2);
        assertEq(_getEthPriceSubmissionByIndex(2), ethSubmission3);
    }

    function test_submitEthPrice_succeedsWithMultipleSubmitters() public {
        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);

        vm.prank(user2);
        oracle.submitEthPrice(ethSubmission2);

        assertEq(_getEthPriceSubmissionByIndex(0), ethSubmission1);
        assertEq(_getEthPriceSubmissionByIndex(1), ethSubmission2);
    }

    function test_submitEthPrice_emitsEthPriceSubmitted() public {
        vm.expectEmit();
        emit IEthPriceOracle.EthPriceSubmitted(user1, ethSubmission1);

        vm.prank(user1);
        oracle.submitEthPrice(ethSubmission1);
    }

    function test_submitEthPrice_failsWhenNotProvider() public {
        vm.expectRevert();

        vm.prank(user3);
        oracle.submitEthPrice(ethSubmission1);
    }
}
