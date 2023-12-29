// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Script, console2} from "forge-std/Script.sol";
import {AutoChain} from "../src/AutoChain.sol";

contract AutoChainDeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
    }
}
