// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChain.sol";
import {AutoChainRental} from "../src/AutoChainRental.sol";
import {AutoChainRentalDeployScript} from "../script/AutoChainRentalDeploy.s.sol";

contract AutoChainRentalTest is Test {
    AutoChainRental public autoChainRental;

    function setUp() public { 
        AutoChainRentalDeployScript autoChainRentalScript = new AutoChainRentalDeployScript();
        autoChainRental = autoChainRentalScript.run();
    }


}
