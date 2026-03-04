// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../../src/week3/Vault.sol";
import {Token} from "../../src/week3/Token.sol";

// RUN
// forge test --match-contract VaultTest -vvv
contract VaultTest is Test {
    Vault public vault;
    Token public token;

    address public deployer = makeAddr("deployer");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");

    uint256 public roundDecimal;

    function setUp() public {
        vm.startPrank(deployer);
        token = new Token("Token", "TKN");
        vault = new Vault(address(token));

        roundDecimal = 10 ** token.decimals();

        token.mint(alice, 100 * roundDecimal);
        token.mint(bob, 100 * roundDecimal);

        token.mint(deployer, 100 * roundDecimal);
        vm.stopPrank();
    }

    // RUN
    // forge test --match-contract VaultTest --match-test testDeposit -vvv
    function testDeposit() public {
        vm.startPrank(alice);
        token.approve(address(vault), 100 * roundDecimal);
        vault.deposit(100 * roundDecimal);
        vm.stopPrank();

        console.log("Alice shares:", vault.userSupplyShares(alice));
        console.log("totalSupplyShares:", vault.totalSupplyShares());
        console.log("totalSupplyAssets:", vault.totalSupplyAssets());

        assertEq(vault.userSupplyShares(alice), 100 * roundDecimal);
    }

    // RUN
    // forge test --match-contract VaultTest --match-test testWithdraw -vvv
    function testWithdraw() public {
        testDeposit();
        vm.startPrank(alice);
        vault.withdraw(100 * roundDecimal); // shares
        vm.stopPrank();
        console.log("============================");
        console.log("Alice shares:", vault.userSupplyShares(alice));
        console.log("totalSupplyShares:", vault.totalSupplyShares());
        console.log("totalSupplyAssets:", vault.totalSupplyAssets());

        assertEq(vault.userSupplyShares(alice), 0);
    }

    // RUN
    // forge test --match-contract VaultTest --match-test testDistributeReward -vvv
    function testDistributeReward() public {
        vm.startPrank(alice);
        token.approve(address(vault), 100 * roundDecimal);
        vault.deposit(100 * roundDecimal);
        vm.stopPrank();
        // alice - 100 Shares
        console.log("============================");
        console.log("alice after shares");
        console.log("alice supply shares = ", vault.userSupplyShares(alice));

        vm.startPrank(bob);
        token.approve(address(vault), 100 * roundDecimal);
        vault.deposit(100 * roundDecimal);
        vm.stopPrank();
        // bob - 100 Shares
        console.log("============================");
        console.log("bob after shares");
        console.log("bob supply shares = ", vault.userSupplyShares(bob));

        vm.startPrank(deployer);
        token.approve(address(vault), 100 * roundDecimal);
        vault.distributeReward(100 * roundDecimal);
        vm.stopPrank();

        // alice = 100 shares
        // bob = 100 shares
        console.log("============================");
        console.log("after distribute reward");
        console.log("alice supply shares = ", vault.userSupplyShares(alice));
        console.log("bob supply shares = ", vault.userSupplyShares(bob));

        vm.startPrank(alice);
        vault.withdraw(100 * roundDecimal);
        vm.stopPrank();
        console.log("============================");
        console.log("alice after withdraw");
        console.log("alice supply shares = ", vault.userSupplyShares(alice));

        vm.startPrank(bob);
        vault.withdraw(100 * roundDecimal);
        vm.stopPrank();
        console.log("============================");
        console.log("bob after withdraw");
        console.log("bob supply shares = ", vault.userSupplyShares(bob));

        console.log("alice balance", token.balanceOf(alice));
        console.log("bob balance", token.balanceOf(bob));
    }
}
