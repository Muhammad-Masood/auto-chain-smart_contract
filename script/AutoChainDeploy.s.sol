// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {AutoChain} from "../src/AutoChain.sol";

contract AutoChainDeployScript is Script {
    address public owner = vm.addr(123);
    
    function run() external returns(AutoChain) {
        vm.startBroadcast();
        vm.prank(owner);
        AutoChain autoChain = new AutoChain();
        console.log("Deployed AutoChain.sol on: ", address(autoChain), "owner: ", owner);
        vm.stopBroadcast();
        return autoChain;
    }
}
