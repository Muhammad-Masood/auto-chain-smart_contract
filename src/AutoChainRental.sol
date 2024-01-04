// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AutoChain} from "./AutoChainNFT.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract AutoChainRental is AutoChain {
    IERC20 private autoChainERC20;
    uint256 private rewardPercentage = 5;
    struct RentalDetails{
        uint256 price;
        uint256 durationFrom;
        uint256 durationTill;
        string terms;
    }

    mapping(uint256 tokenId => RentalDetails) private tokenIdToRentalDetails;

    // Events
    event CarListed (uint256 indexed _tokenId, address indexed _owner);
    event CarRented (uint256 indexed _tokenId, address _renter, uint256 indexed _price, uint256 _reward);

    // Errors

    error IsAlreadyRented();
    error RentTransferFailed();
    error NotForRent();
    error InvalidOwner(address);

    constructor(address _erc20tokenAddress) {
        autoChainERC20 = IERC20(_erc20tokenAddress);
        autoChainERC20.approve(address(this), autoChainERC20.totalSupply());
    }

    // list car for rent
    function list(uint256 _tokenId, RentalDetails memory _rentalDetails) external {
        address owner = _requireOwned(_tokenId);
        if(msg.sender!=owner) revert InvalidOwner(owner);
        if(block.timestamp < tokenIdToRentalDetails[_tokenId].durationTill )  revert IsAlreadyRented();
        tokenIdToRentalDetails[_tokenId] = _rentalDetails;
        emit CarListed(_tokenId, owner);
    }

    // rent the listed car
    // the renter will be incentivised by 10% * amount of rent
    function rent(uint256 _tokenId) external {
        if(tokenIdToRentalDetails[_tokenId].price == 0 )  revert NotForRent();
        address currentCarOwner =  _requireOwned(_tokenId);
        uint256 rentPrice = tokenIdToRentalDetails[_tokenId].price;
        (bool success, ) = currentCarOwner.call{value: rentPrice}("");
        if(!success) revert RentTransferFailed();
        uint256 rewardAmount = (rewardPercentage * rentPrice) / 100;
        autoChainERC20.transferFrom(owner(), msg.sender, rewardAmount);
        emit CarRented(_tokenId, msg.sender, rentPrice, rewardAmount);
    }

    // view functions

    function getCarRentalDetails(uint256 _tokenId) public view returns(RentalDetails memory){
        return tokenIdToRentalDetails[_tokenId];
    }

    function getERC20TokenAddress() public view returns (address){
        return address(autoChainERC20);
    }

    function getRewardPercentage() public view returns (uint256){
        return rewardPercentage;
    }
}
