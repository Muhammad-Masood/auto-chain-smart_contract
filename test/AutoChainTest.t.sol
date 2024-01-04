// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChainNFT.sol";
import {AutoChainNFTDeployScript} from "../script/AutoChainNFTDeploy.s.sol";

contract AutoChainTest is Test {
    AutoChain public autoChain;
    address public deployer = vm.addr(123);
    address public user = vm.addr(2233);

    error OwnableUnauthorizedAccount(address account);

    function setUp() public {
        vm.startPrank(deployer);
        AutoChainNFTDeployScript autoChainScript = new AutoChainNFTDeployScript();
        autoChain = autoChainScript.run();
        vm.stopPrank();
        console.log(user);
        console.log(deployer);
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
        vm.expectRevert(OwnableUnauthorizedAccount.selector);
        vm.prank(user);
        autoChain.mint("token_1_uri");
    }
}
