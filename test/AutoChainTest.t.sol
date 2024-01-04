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

    function test_RevertIfMinterIsNotOwner() public {
        vm.expectRevert(OwnableUnauthorizedAccount.selector);
        vm.prank(user);
        autoChain.mint("token_1_uri");
    }

    function test_mintShouldIncreaseTotalSupply() public mintToken {
        uint256 totalSupply = autoChain.getTotalSupply();
        assertEq(totalSupply,1);
    }

    function test_mintShouldSetTokenURI() public mintToken {
        uint256 tokenId = 0;
        uint256 tokenURI = autoChain.tokenURI(tokenId);
        assertEq(tokenURI,"token_1_uri");
        // should revert if passed wrong token Id
        expectRevert();
        tokenId = autoChain.tokenURI(1);
    }

    
}
