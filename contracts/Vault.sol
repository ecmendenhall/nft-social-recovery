//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Vault is ERC721Holder {

    address public controller;
    mapping(address => bool) internal allowedTokens;

    constructor(address _controller) {
        controller = _controller;
    }

    function withdraw(address token, address to, uint256 tokenId) public {
        require(msg.sender == controller, "Unauthorized transfer");
        require(allowedTokens[token], "Unknown token address");
        IERC721(token).safeTransferFrom(address(this), to, tokenId);
    }
    
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public override returns (bytes4) {
        allowedTokens[msg.sender] = true;
        return this.onERC721Received.selector;
    }
}