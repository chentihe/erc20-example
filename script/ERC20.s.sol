// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ERC20.sol";

contract ERC20Script is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new ERC20("YOUR_TOKEN_NAME", "YOUR_TOKEN_SYMBOL", 6);
        vm.stopBroadcast();
    }
}