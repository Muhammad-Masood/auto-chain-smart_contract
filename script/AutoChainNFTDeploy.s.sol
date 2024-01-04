// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {AutoChain} from "../src/AutoChainNFT.sol";

contract AutoChainNFTDeployScript is Script {
    address public owner = vm.addr(123);
    
    function run() external returns(AutoChain) {
        vm.startBroadcast();
        AutoChain autoChain = new AutoChain();
        vm.stopBroadcast();
        console.log("Deployed AutoChain.sol on: ", address(autoChain), "owner: ", autoChain.owner());
        console.log(address(this));
        return autoChain;
    }
}
