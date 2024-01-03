// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChain.sol";
import {AutoChainRental} from "../src/AutoChainRental.sol";

contract AutoChainRentalTest is Test {
    AutoChain public autoChain;
    AutoChainRental public autoChainRental;

    function setUp() public { 
        autoChainRental = new AutoChainRental();
    }

    function test_Increment() public {
       
    }

    function testFuzz_SetNumber(uint256 x) public {
        
    }
}
