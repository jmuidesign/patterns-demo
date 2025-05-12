// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Vm} from "forge-std/Vm.sol";
import {EthPriceOracle} from "../src/contracts/EthPriceOracle.sol";

contract Anvil is Script, StdCheats {
    function run() public {
        EthPriceOracle oracle = new EthPriceOracle();

        console.log("Oracle deployed at", address(oracle));
    }
}
