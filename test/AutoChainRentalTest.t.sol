// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Test, console2, console} from "forge-std/Test.sol";
// import {AutoChain} from "../src/AutoChainNFT.sol";
import {AutoChainRental} from "../src/AutoChainRental.sol";
import {AutoChainRentalDeployScript} from "../script/AutoChainRentalDeploy.s.sol";
import {AutoChain} from "../src/AutoChain.sol";

contract AutoChainRentalTest is Test {
    AutoChainRental public autoChainRental;
    AutoChain public autoChainERC20;
    // address owner = payable(makeAddr("owner"));
    address owner;
    address user = payable(makeAddr("user"));
    uint256 tokenIdMinted;

    function setUp() public {
        AutoChainRentalDeployScript autoChainRentalScript = new AutoChainRentalDeployScript();
        (autoChainRental, autoChainERC20) = autoChainRentalScript.run();
        // vm.prank(autoChainRental.owner());
        // autoChainRental.transferOwnership(owner);
        owner = payable(autoChainRental.owner());
        tokenIdMinted = 0;
        console.log("rental_test: ",address(this));
    }

    modifier listVehicle() {
        vm.startPrank(owner);
        autoChainRental.mint("token_uri");
        autoChainRental.addListing(
            tokenIdMinted,
            AutoChainRental.RentalDetails(
                10e18,
                1705026202,
                1705044201,
                "terms&cond"
            )
        );
        vm.stopPrank();
        _;
    }

    // test vehicle listing feature

    function test_ShouldRevertIfTokenIdNotExist() public {}

    function test_ShouldRevertIfListerIsNotOwnerOfVehicle() public {}

    function test_ShouldRevertIfDurationTillNotPassed() public {}

    // test vehicle rent feature

    function test_ShouldRevertIfVehiclNotListed() public {
        uint256 _tokenId = 0;
        vm.expectRevert(AutoChainRental.NotForRent.selector);
        autoChainRental.rent(_tokenId);
    }

    function test_ShouldRevertOnSendingWrongAmount() public listVehicle {
        // listed by the owner, user have 0 BNB initially.
        // uint256 rentPrice = autoChainRental.carRentalDetails(tokenIdMinted).price;
        // uint256 purchasingAmount = rentPrice - 1e18;
        vm.expectRevert(AutoChainRental.RentTransferFailed.selector);
        vm.prank(user);
        autoChainRental.rent(tokenIdMinted);
    }

    function test_ShouldTransferRightAmount() public listVehicle {
        uint256 rentPrice = autoChainRental.carRentalDetails(tokenIdMinted).price;
        vm.deal(user, rentPrice+5e18); // additional for gas.
        uint256 beforeOwnerBalance = owner.balance;
        console.log(rentPrice, user.balance);
        console.log(autoChainERC20.balanceOf(owner));
        // vm.expectEmit();
        // emit AutoChainRental.CarRented(tokenIdMinted, user, rentPrice, 1e19);
        console.log("allowance: ",autoChainERC20.allowance(owner, address(autoChainRental)));
        vm.prank(user);
        autoChainRental.rent{value: rentPrice}(tokenIdMinted);
        uint256 expectedOwnerBalance = beforeOwnerBalance + rentPrice;
        assertEq(owner.balance, expectedOwnerBalance);
    }
}

// 0xc28482582217E3e65A4f0cbeE5A9F0EDFbB1B08E
// 0x0F5fC1A228CC5Bf1F275315e1c8bEcDeF9800Da9