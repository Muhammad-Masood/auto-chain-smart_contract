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
    }

    mapping(uint256 tokenId => RentalDetails) private tokenIdToRentalDetails;

    // Events

    event (uint256 indexed _tokenId, address _renter) CarRented;

    constructor() {}

    function listCar(uint256 _tokenId, RentalDetails memory _rentalDetails) external {
        tokenIdToRentalDetails[_tokenId] = _rentalDetails;
        
    }

    function rentCar(uint256 _tokenId) external {
        address owner = _requireOwned(_tokenId);
        // transfer
        emit CarRented(_tokenId, msg.sender);
    }

    // view functions

    function getCarRentalDetails(uint256 _tokenId) public view returns(RentalDetails memory){
        return tokenIdToRentalDetails[_tokenId];
    }
}
