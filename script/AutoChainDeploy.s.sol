// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {AutoChain} from "../src/AutoChain.sol";

contract AutoChainDeployScript is Script {

    function run() external returns(AutoChain) {
        vm.startBroadcast();
        AutoChain autoChain = new AutoChain();
        console.log("Deployed AutoChain.sol on: ", address(autoChain));
        vm.stopBroadcast();
        return autoChain;
    }
}
