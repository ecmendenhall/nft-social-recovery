//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNFT is ERC721("Mock NFT", "NFT") {

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}