// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {AutoChainRental} from "../src/AutoChainRental.sol";
import {AutoChain} from "../src/AutoChain.sol";

// This contract deploys both Auto Chain NFT contract and Rental contract. 

contract AutoChainRentalDeployScript is Script {
    address public owner = vm.addr(123);
    uint256 public totalSupply = 1000*10**18; 

    function run() external returns(AutoChainRental) {
        vm.startBroadcast();
        vm.startPrank(owner);
        AutoChain autoChain = new AutoChain(); // ERC20 token
        AutoChainRental autoChainRental = new AutoChainRental(address(autoChain));
        vm.stopPrank();
        console.log("Deployed AutoChainRental.sol on: ", address(autoChainRental));
        vm.stopBroadcast();
        return autoChainRental;
    }
}
