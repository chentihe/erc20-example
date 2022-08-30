// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ERC20.sol";

contract ERC20Script is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        ERC20 erc20 = new ERC20();
        vm.stopBroadcast();
    }
}