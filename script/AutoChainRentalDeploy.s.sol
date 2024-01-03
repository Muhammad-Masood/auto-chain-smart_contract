// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
// import {AutoChain} from "../src/AutoChain.sol";
import {AutoChainRental} from "../src/AutoChainRental.sol";

contract AutoChainRentalDeployScript is Script {

    function run() external returns(AutoChainRental) {
        vm.startBroadcast();
        AutoChainRental autoChainRental = new AutoChainRental();
        console.log("Deployed AutoChainRental.sol on: ", address(autoChainRental));
        vm.stopBroadcast();
        return autoChainRental;
    }
}
