// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AutoChain} from "./AutoChain.sol";

contract AutoChainRental is AutoChain {
    
    struct RentalDetails{
        uint256 price;
        uint256 durationFrom;
        uint256 durationTill;
        string terms;
        bool isRented;
    }

    mapping(uint256 tokenId => RentalDetails) private tokenIdToRentalDetails;

    // Events
    event CarRented (uint256 indexed _tokenId, address _renter, uint256 indexed _price);

    // Errors

    error IsAlreadyRented();
    error RentTransferFailed();

    constructor() {}

    // list car for rent
    function listCar(uint256 _tokenId, RentalDetails memory _rentalDetails) external {
        _requireOwned(_tokenId);
        if(tokenIdToRentalDetails[_tokenId].isRented) revert IsAlreadyRented();
        tokenIdToRentalDetails[_tokenId] = _rentalDetails;
    }

    // rent the listed car
    function rentCar(uint256 _tokenId) external {
        if(tokenIdToRentalDetails[_tokenId].isRented) revert IsAlreadyRented();
        address owner =  _requireOwned(_tokenId);
        uint256 rentPrice = tokenIdToRentalDetails[_tokenId].price;
        (bool success, ) = owner.call{value: rentPrice}("");
        if(!success) revert RentTransferFailed();
        tokenIdToRentalDetails[_tokenId].isRented = true;
        emit CarRented(_tokenId, msg.sender, rentPrice);
    }

    // view functions

    function getCarRentalDetails(uint256 _tokenId) public view returns(RentalDetails memory){
        return tokenIdToRentalDetails[_tokenId];
    }
}