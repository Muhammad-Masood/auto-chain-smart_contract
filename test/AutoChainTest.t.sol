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

    // all tokens will be minted at the address of the owner
    function test_MintShouldSetRightOwnerAfterMint() public mintToken {
        uint256 tokenId =  0;
        address newOwner = autoChain._ownerOf(tokenId);
        assertEq(newOwner,owner);
    }

    function test_MintShouldIncreaseTotalSupplyAndMinterBalance() public {
        uint256 prevBalance = autoChain.balanceOf(owner);
        uint256 prevTotalSupply = autoChain.getTotalSupply();
        vm.prank(owner);
        autoChain.mint("new_token_uri");
        uint256 newBalance = autoChain.balanceOf(owner);
        uint256 newTotalSupply = autoChain.getTotalSupply();
        assertEq(newTotalSupply,prevTotalSupply+1);
        assertEq(new,prevTotalSupply+1);        
    }

    function test_MintShouldSetRightTokenURI() public mintToken {
        uint256 tokenId = 0;
        string memory tokenURI = autoChain.tokenURI(tokenId);
        assertEq(tokenURI,"token_1_uri");
    }
    
}
