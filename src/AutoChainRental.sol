// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AutoChain} from "./AutoChainNFT.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract AutoChainRental is AutoChain {
    IERC20 private autoChainERC20;
    uint256 private rewardPercentage = 10;
    enum RentStatus {
        None,
        Listed,
        Rented
    }

    struct RentalDetails {
        uint256 price;
        uint256 durationFrom;
        uint256 durationTill;
        string terms;
    }

    mapping(uint256 tokenId => RentalDetails) private tokenIdToRentalDetails;
    mapping(address user => uint256[] tokenIdsRented)
        private addressToRentedTokenIds;
    mapping(address user => uint256[] tokenIdsListed)
        private addressToListedTokenIds;
    mapping(uint256 tokenId => RentStatus rentStatus)
        private tokenIdToRentStatus;

    // Events
    event CarListed(uint256 indexed _tokenId, address indexed _owner);
    event CarRented(
        uint256 indexed _tokenId,
        address _renter,
        uint256 indexed _price,
        uint256 _reward
    );

    // Errors

    error IsAlreadyRented();
    error RentTransferFailed();
    error NotForRent();
    error InvalidOwner(address);

    constructor(address _erc20tokenAddress) {
        autoChainERC20 = IERC20(_erc20tokenAddress);
        // autoChainERC20.approve(address(this), autoChainERC20.totalSupply());
    }

    // list car for rent
    function addListing(
        uint256 _tokenId,
        RentalDetails memory _rentalDetails
    ) external {
        address owner = _requireOwned(_tokenId);
        if (msg.sender != owner) revert InvalidOwner(owner);
        if (block.timestamp < tokenIdToRentalDetails[_tokenId].durationTill)
            revert IsAlreadyRented();
        tokenIdToRentalDetails[_tokenId] = _rentalDetails;
        tokenIdToRentStatus[_tokenId] = RentStatus.Listed;
        addressToListedTokenIds[owner].push(_tokenId);
        emit CarListed(_tokenId, owner);
    }

    // rent the listed car
    // the renter will be incentivised by 10% * amount of rent
    function rent(uint256 _tokenId) external payable {
        uint256 rentPrice = tokenIdToRentalDetails[_tokenId].price;
        if (rentPrice == 0) revert NotForRent();
        address currentCarOwner = _requireOwned(_tokenId);
        (bool success, ) = currentCarOwner.call{value: rentPrice}("");
        if (!success) revert RentTransferFailed();
        uint256 rewardAmount = (rewardPercentage * rentPrice) / 100;
        autoChainERC20.transferFrom(owner(), msg.sender, rewardAmount);
        tokenIdToRentStatus[_tokenId] = RentStatus.Rented;
        addressToRentedTokenIds[msg.sender].push(_tokenId);
        emit CarRented(_tokenId, msg.sender, rentPrice, rewardAmount);
    }

    // view functions

    function carRentalDetails(
        uint256 _tokenId
    ) public view returns (RentalDetails memory) {
        return tokenIdToRentalDetails[_tokenId];
    }

    function erc20TokenAddress() public view returns (address) {
        return address(autoChainERC20);
    }

    function getRewardPercentage() public view returns (uint256) {
        return rewardPercentage;
    }

    function rentStatus(uint256 _tokenId) public view returns (RentStatus) {
        return tokenIdToRentStatus[_tokenId];
    }

    function tokenIdsListed(
        address user
    ) public view returns (uint256[] memory) {
        return addressToListedTokenIds[user];
    }

    function tokenIdsRented(
        address user
    ) public view returns (uint256[] memory) {
        return addressToRentedTokenIds[user];
    }
}
