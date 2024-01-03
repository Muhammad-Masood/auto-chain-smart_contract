// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChain.sol";
import {AutoChainDeployScript} from "../script/AutoChainDeploy.s.sol";

contract AutoChainTest is Test {
    AutoChain public autoChain;
    address public deployer;

    function setUp() public {
        AutoChainDeployScript autoChainDeployScript = new AutoChainDeployScript();
        (autoChain, deployer) = autoChainDeployScript.run();
    }

    function test_DeployerShouldBeOwner() public {
        assert(autoChain.owner(),deployer);
    }

    function test_OnlyOwnerCanMintNewTokens() public {

    }
   
}
