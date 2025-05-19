// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Vm} from "forge-std/Vm.sol";
import {TestERC1155} from "../src/TestERC1155.sol";

contract DeployAnvil is Script, StdCheats {
    function run() public {
        Vm.Wallet memory wallet1 = vm.createWallet(vm.envUint("PRIVATE_KEY_1"));

        vm.startBroadcast(wallet1.privateKey);

        TestERC1155 testERC1155 = new TestERC1155();

        console.log("TestERC1155 deployed at:", address(testERC1155));

        vm.stopBroadcast();
    }
}
