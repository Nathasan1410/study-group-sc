// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Token} from "../../src/week3/Token.sol";

// RUN
// forge test --match-contract TokenTest
contract TokenTest is Test {
    Token public token;

    address public owner = makeAddr("owner");

    address public alice = makeAddr("alice");

    uint256 public roundDecimal;

    function setUp() public {
        vm.startPrank(owner);
        token = new Token("UKDW", "UKDW");
        roundDecimal = 10 ** uint256(token.decimals());
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract TokenTest --match-test testMint -vvv
    function testMint() public {
        vm.startPrank(owner);
        token.mint(alice, 100 * roundDecimal);
        vm.stopPrank();

        console.log("Alice balance:", token.balanceOf(alice));

        _tokenFunction();

        assertEq(token.balanceOf(alice), 100 * roundDecimal);
    }

    // RUN
    // forge test --match-contract TokenTest --match-test testBurn -vvv
    function testBurn() public {
        vm.startPrank(owner);
        token.mint(alice, 100 * roundDecimal);
        token.burn(alice, 50 * roundDecimal);
        vm.stopPrank();

        _tokenFunction();

        assertEq(token.balanceOf(alice), 50 * roundDecimal);
    }

    // RUN
    // forge test --match-contract TokenTest --match-test testRevertMint -vvv
    function testRevertMint() public {
        vm.startPrank(alice);
        vm.expectRevert();
        token.mint(alice, 100 * roundDecimal);
        vm.stopPrank();
    }

    function _tokenFunction() internal view {
        console.log("Token name:", token.name());
        console.log("Token symbol:", token.symbol());
        console.log("Token decimals:", token.decimals());
        console.log("Token total supply:", token.totalSupply());
    }
}
