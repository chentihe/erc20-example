// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;

    address owner = makeAddr("owner");
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address cathy = makeAddr("cathy");

    uint256 constant transferAmount = 100_000 * 1e6 wei;

    function setUp() public {
        vm.startPrank(owner);
        erc20 = new ERC20("Test Token", "TT", 6);
        erc20.transfer(alice, transferAmount);
        erc20.transfer(bob, transferAmount);
    }

    function testBalanceOf() public {
        uint256 aliceBalance = erc20.balanceOf(alice);
        assertEq(aliceBalance, transferAmount);
    }

    function testApprove() public {
        changePrank(alice);
        bool result = erc20.approve(bob, 500 * 1e6);
        assertTrue(result);
        vm.stopPrank();
    }

    function testTransfer() public {
        changePrank(alice);
        uint256 transfer = 500 * 1e6;
        uint256 beforeTransfer = erc20.balanceOf(cathy);
        erc20.transfer(cathy, transfer);
        uint256 afterTransfer = erc20.balanceOf(cathy);
        assertEq(afterTransfer - beforeTransfer, transfer);
        vm.stopPrank();
    }

    function testTransferFrom() public {
        changePrank(alice);
        uint256 allowance = 500 * 1e6;
        erc20.approve(bob, allowance);
        changePrank(bob);
        uint256 transfer = 100 * 1e6;
        uint256 beforeTransfer = erc20.balanceOf(cathy);
        erc20.transferFrom(alice, cathy, transfer);
        uint256 afterTransfer = erc20.balanceOf(cathy);
        assertEq(afterTransfer - beforeTransfer, transfer);
        vm.stopPrank();
    }

    function testSendToMultiUser() public {
        address[] memory userList = new address[](3);
        userList[0] = alice;
        userList[1] = bob;
        userList[2] = cathy;
        uint256 transfer = 100 * 1e6;
        uint256 beforeTransferA = erc20.balanceOf(alice);
        uint256 beforeTransferB = erc20.balanceOf(bob);
        uint256 beforeTransferC = erc20.balanceOf(cathy);
        erc20.sendToMutiUser(userList, transfer);
        uint256 afterTransferA = erc20.balanceOf(alice);
        uint256 afterTransferB = erc20.balanceOf(bob);
        uint256 afterTransferC = erc20.balanceOf(cathy);
        assertEq(afterTransferA - beforeTransferA, transfer);
        assertEq(afterTransferB - beforeTransferB, transfer);
        assertEq(afterTransferC - beforeTransferC, transfer);
    }

    function testClaim() public {
        uint256 claimAmount = 500_000 * 1e6;
        uint256 beforeClaim = erc20.balanceOf(owner);
        erc20.claim();
        uint256 afterClaim = erc20.balanceOf(owner);
        assertEq(afterClaim - beforeClaim, claimAmount);
    }

    function testWithdraw() public {
        uint256 withdrawAmount = 500_000 * 1e6;
        uint256 beforeWithdraw = erc20.balanceOf(owner);
        erc20.withdraw(withdrawAmount);
        uint256 afterWithdraw = erc20.balanceOf(owner);
        assertEq(afterWithdraw - beforeWithdraw, withdrawAmount);
    }
}
