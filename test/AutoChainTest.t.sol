// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChain.sol";

contract AutoChainTest is Test {
    AutoChain public autoChain;

    function setUp() public { 
        autoChain = new AutoChain();
    }

    function test_Increment() public {
       
    }

    function testFuzz_SetNumber(uint256 x) public {
        
    }
}
