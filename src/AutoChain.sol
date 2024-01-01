// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AutoChain is ERC721, Ownable {
    string private baseURI;
    mapping(uint256 tokenId => string[]) private carToMaintenanceHistory;

    constructor(string memory __baseURI) ERC721("AutoChain", "AC") Ownable(msg.sender) {
        updateBaseURI(__baseURI);
    }

    /**
     * launch new car or mint new token
     * @param _to user address at which the nft should be minted
     */

    function mint(address _to, uint256 _tokenId) external onlyOwner {
        _safeMint(_to, _tokenId);
    }

    /**
     * destroy or withdraw car
     * @param _tokenId token id to burn
     * only owner can withdraw existing cars
     */

    function burn(uint256 _tokenId) external onlyOwner {
        _burn(_tokenId);
    }

    function updateBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function updateMaintenanceHistory(uint256 _tokenId, string memory _update) external {
        carToMaintenanceHistory[_tokenId].push(_update);
    }

    // public functions

    function getMaintenanceHistory(uint256 _tokenId) public view returns (string[] memory maintenanceHistory) {
        return carToMaintenanceHistory[_tokenId];
    }

    // internal functions

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }
}
