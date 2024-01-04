// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
import {AutoChain} from "../src/AutoChainNFT.sol";
import {AutoChainNFTDeployScript} from "../script/AutoChainNFTDeploy.s.sol";

contract AutoChainTest is Test {
    AutoChain public autoChain;
    address public user = vm.addr(2233);
    address public owner;

    error OwnableUnauthorizedAccount(address account);

    function setUp() public {
        AutoChainNFTDeployScript autoChainScript = new AutoChainNFTDeployScript();
        autoChain = autoChainScript.run();
        owner = autoChain.owner();
    }

    modifier mintToken(){
        vm.prank(owner);
        autoChain.mint("new_token_uri");
        _;
    }

    function testFail_IfMinterIsNotOwner() public {
        vm.expectRevert(OwnableUnauthorizedAccount.selector);
        vm.prank(user);
        autoChain.mint("token_1_uri");
    }

    
}
