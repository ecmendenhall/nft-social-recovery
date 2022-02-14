// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../lib/ds-test/src/test.sol";
import "./MockNFT.sol";

import "../Vault.sol";

contract VaultTest is DSTest {

    MockNFT internal nft;
    Vault internal vault;

    function setUp() public {
        nft = new MockNFT();
        vault = new Vault();
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
}