// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChain.sol";
import {AutoChainDeployScript} from "../script/AutoChainDeploy.s.sol";

contract AutoChainTest is Test {
    AutoChain public autoChain;
    address public deployer;
    address public user = vm.addr(123);

    function setUp() public {
        AutoChainDeployScript autoChainScript = new AutoChainDeployScript(user, );
        autoChain = autoChainScript.run();
        console.log(user);
    }

    modifier mintToken(){
        vm.prank(deployer);
        autoChain.mint("new_token_uri");
        _;
    }

    function test_DeployerShouldBeOwner() public {
        assertEq(autoChain.owner(),deployer);
    }

    function testFail_IfMinterIsNotOwner() public {
        vm.prank(user);
        autoChain.mint("token_1_uri");
    }
   
}
