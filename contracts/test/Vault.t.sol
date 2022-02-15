// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../../lib/ds-test/src/test.sol";
import "./MockNFT.sol";

import "../Vault.sol";

contract User is ERC721Holder {

    MockNFT internal nft;
    Vault internal vault;

    constructor(MockNFT _nft) {
        nft = _nft;
    }

    function setVault(Vault _vault) public {
        vault = _vault;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        nft.safeTransferFrom(from, to, tokenId);
    }

    function withdraw(address token, address to, uint256 tokenId) public {
        vault.withdraw(token, to, tokenId);
    }
}

contract VaultTest is DSTest {

    MockNFT internal nft;
    Vault internal vault;
    User internal controller;
    User internal other_user;

    function setUp() public {
        nft = new MockNFT();
        controller = new User(nft);
        other_user = new User(nft);
        vault = new Vault(address(controller));
        controller.setVault(vault);
        other_user.setVault(vault);
    }

    function test_accepts_erc721_mint() public {
        assertEq(nft.balanceOf(address(vault)), 0);

        nft.mint(address(vault), 1);

        assertEq(nft.balanceOf(address(vault)), 1);
    }
    
    function test_accepts_erc721_transfer() public {
        nft.mint(address(this), 1);
        assertEq(nft.balanceOf(address(vault)), 0);

        nft.safeTransferFrom(address(this), address(vault), 1);

        assertEq(nft.balanceOf(address(vault)), 1);
    }

    function test_accepts_erc721_ownership() public {
        nft.mint(address(this), 1);
        
        nft.safeTransferFrom(address(this), address(vault), 1);

        assertEq(address(vault), nft.ownerOf(1));
    }
    
    function test_controller_can_withdraw_token() public {
        nft.mint(address(this), 1);
        nft.safeTransferFrom(address(this), address(vault), 1);

        controller.withdraw(address(nft), address(controller), 1);

        assertEq(address(controller), nft.ownerOf(1));
    }
    
    function test_withdraw_reverts_on_untrusted_token() public {
        try controller.withdraw(address(0), address(controller), 1) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Unknown token address");
        }
    }
    
    function test_other_user_cannot_withdraw_token() public {
        try other_user.withdraw(address(nft), address(other_user), 1) {
            fail();
        } catch Error(string memory error) {
            assertEq(error, "Unauthorized transfer");
        }
    }
    
    function test_stores_current_controller() public {
        assertEq(vault.controller(), address(controller));
    }
}