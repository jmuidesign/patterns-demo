// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {EthPriceOracle} from "../src/contracts/EthPriceOracle.sol";
import {IEthPriceOracle} from "../src/interfaces/IEthPriceOracle.sol";

contract SubmitEthPriceTest is Test {
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
        emit IEthPriceOracle.EthPriceSubmitted(address(this), ethSubmission1);

        oracle.submitEthPrice(ethSubmission1);
    }

    function _getEthPriceSubmissionByIndex(uint256 index) internal view returns (uint256 ethPriceSubmission) {
        bytes32 lengthSlot = keccak256(abi.encode(3));
        bytes32 indexSlot = vm.load(address(oracle), bytes32(uint256(lengthSlot) + index));

        ethPriceSubmission = uint256(indexSlot);
    }
}
