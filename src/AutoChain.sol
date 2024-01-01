// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AutoChain is ERC721, Ownable {
    uint256 private totalSupply;
    mapping(uint256 tokenId => string[]) private carToMaintenanceHistory;

    constructor() ERC721("AutoChain", "AC") Ownable(msg.sender) {}

    /**
     * launch new car or mint new token
     * @param _to user address at which the nft should be minted
     */

    function mint() external onlyOwner {
        _safeMint(msg.sender, totalSupply);
        totalSupply+=1;
    }

    /**
     * destroy or withdraw car
     * @param _tokenId token id to burn
     * only owner can withdraw existing cars
     */

    function burn(uint256 _tokenId) external onlyOwner {
        _burn(_tokenId);
    }

    function updateMaintenanceHistory(uint256 _tokenId, string memory _update) external {
        carToMaintenanceHistory[_tokenId].push(_update);
    }

    // public functions

    function getMaintenanceHistory(uint256 _tokenId) public view returns (string[] memory maintenanceHistory) {
        return carToMaintenanceHistory[_tokenId];
    }

    function getTotalSupply() public view returns(uint256){
        return totalSupply;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString()) : "";
    }

    // internal functions

}
