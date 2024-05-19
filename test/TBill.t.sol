// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import "../src/TBill.sol";


contract TBillTest is Test {
    TBill public tBill;
    address owner;

    function setUp() public {
        owner = vm.addr(1);
        tBill = new TBill(owner);
    }

    function test_Increment() public {

    }

    function testFuzz_SetNumber(uint256 x) public {

    }
}
