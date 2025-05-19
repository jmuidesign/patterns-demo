// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import {Script} from "forge-std/Script.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {Vm} from "forge-std/Vm.sol";
import {TestERC1155} from "../src/TestERC1155.sol";

contract DoSomeTransactions is Script, StdCheats {
    uint256[] public ids = [0, 1, 2, 3, 4];
    uint256[] public valueSetOne = [10, 10, 10, 10, 10];
    uint256[] public valueSetTwo = [2, 2, 5, 5, 1];

    function run() public {
        Vm.Wallet memory wallet1 = vm.createWallet(vm.envUint("PRIVATE_KEY_1"));
        Vm.Wallet memory wallet2 = vm.createWallet(vm.envUint("PRIVATE_KEY_2"));

        vm.startBroadcast(wallet1.privateKey);

        TestERC1155 testERC1155 = TestERC1155(0x5FbDB2315678afecb367f032d93F642f64180aa3);

        testERC1155.mintBatch(wallet1.addr, ids, valueSetOne, "");

        testERC1155.safeTransferFrom(wallet1.addr, wallet2.addr, ids[0], valueSetOne[0], "");
        testERC1155.safeTransferFrom(wallet1.addr, wallet2.addr, ids[1], valueSetOne[1], "");
        testERC1155.safeTransferFrom(wallet1.addr, wallet2.addr, ids[2], valueSetOne[2], "");
        testERC1155.safeTransferFrom(wallet1.addr, wallet2.addr, ids[3], valueSetOne[3], "");
        testERC1155.safeTransferFrom(wallet1.addr, wallet2.addr, ids[4], valueSetOne[4], "");

        vm.stopBroadcast();

        vm.startBroadcast(wallet2.privateKey);

        testERC1155.safeBatchTransferFrom(wallet2.addr, wallet1.addr, ids, valueSetTwo, "");

        vm.stopBroadcast();
    }
}
