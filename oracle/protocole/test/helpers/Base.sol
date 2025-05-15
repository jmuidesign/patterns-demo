// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {EthPriceOracle} from "../../src/contracts/EthPriceOracle.sol";
import {IEthPriceOracle} from "../../src/interfaces/IEthPriceOracle.sol";

abstract contract BaseTest is Test {
    bytes32 public constant PROVIDER_ROLE = keccak256("PROVIDER_ROLE");

    address public user1;
    address public user2;
    address public user3;

    uint256 public ethSubmission1;
    uint256 public ethSubmission2;
    uint256 public ethSubmission3;

    EthPriceOracle public oracle;

    function setUp() public virtual {
        user1 = address(1);
        user2 = address(2);
        user3 = address(3);

        ethSubmission1 = 100000;
        ethSubmission2 = 100100;
        ethSubmission3 = 99900;

        oracle = new EthPriceOracle();

        oracle.grantRole(PROVIDER_ROLE, user1);
        oracle.grantRole(PROVIDER_ROLE, user2);
    }

    function _getEthPriceExpected() internal view returns (uint256) {
        return (ethSubmission1 + ethSubmission2) / 2;
    }

    function _getEthPriceSubmissionsLength() internal view returns (uint256 length) {
        bytes32 lengthSlot = keccak256(abi.encode(3));

        return uint256(vm.load(address(oracle), lengthSlot));
    }

    function _getEthPriceSubmissionByIndex(uint256 index) internal view returns (uint256 ethPriceSubmission) {
        bytes32 lengthSlot = keccak256(abi.encode(3));
        bytes32 indexSlot = vm.load(address(oracle), bytes32(uint256(lengthSlot) + index));

        ethPriceSubmission = uint256(indexSlot);
    }

    function _setEthPriceSubmissionsLengthToMaxSubmissions() internal {
        for (uint256 i = 0; i < 50; i++) {
            vm.prank(user1);
            oracle.submitEthPrice(ethSubmission1);

            vm.prank(user2);
            oracle.submitEthPrice(ethSubmission2);
        }
    }

    function _setEthPriceSubmissionsLengthToMaxSubmissionsMinusOne() internal {
        for (uint256 i = 0; i < 50; i++) {
            vm.prank(user1);
            oracle.submitEthPrice(ethSubmission1);
        }

        for (uint256 i = 0; i < 49; i++) {
            vm.prank(user2);
            oracle.submitEthPrice(ethSubmission2);
        }
    }
}
