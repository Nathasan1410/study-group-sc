// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Redstone} from "src/week2/Redstone.sol";

contract RedstoneTest is Test {
    Redstone public redstone;

    address public constant BTC_USD = 0x3587a73AA02519335A8a6053a97657BECe0bC2Cc;
    address public constant ETH_USD = 0x4BAD96DD1C7D541270a0C92e1D4e5f12EEEA7a57;

    uint8 public constant BTC_DECIMALS = 8;
    uint8 public constant ETH_DECIMALS = 18;

    Redstone public redstoneBtc;
    Redstone public redstoneEth;

    function setUp() public {
        vm.createSelectFork("hyperevm_testnet");
        redstoneBtc = new Redstone(BTC_USD);
        redstoneEth = new Redstone(ETH_USD);
    }

    // forge test --match-contract RedstoneTest --match-test testLatestRoundData -vvv
    function testLatestRoundData() public view {
        (, int256 priceBtc,,,) = redstoneBtc.latestRoundData();
        (, int256 priceEth,,,) = redstoneEth.latestRoundData();
        // console.log("Price", price / 1e8);
        uint8 decimalsBtc = redstoneBtc.decimals();
        uint8 decimalsEth = redstoneEth.decimals();

        // PRICE BTC
        // console.log("Price BTC/USD", uint256(priceBtc) / (10 ** uint256(decimalsBtc)));
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log("Price BTC/USD", uint256(priceBtc));

        // PRICE ETH
        // console.log("Price ETH/USD", uint256(priceEth) / (10 ** uint256(decimalsEth)) );
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log("Price ETH/USD", uint256(priceEth));

        // PRICE BTC/ETH
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log("Price BTC/ETH", uint256(priceBtc) / uint256(priceEth));

        // Conversion BTC/ETH
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log("Price BTC/ETH", (uint256(priceBtc) * 10 ** uint256(decimalsEth)) / uint256(priceEth));

        // Conversion ETH/BTC
        // forge-lint: disable-next-line(unsafe-typecast)
        console.log("Price ETH/BTC", (uint256(priceEth) * 10 ** uint256(decimalsBtc)) / uint256(priceBtc));
    }

    // forge test --match-contract RedstoneTest --match-test testDecimals -vvv
    function testDecimals() public view {
        uint8 decimals = redstone.decimals();
        assertEq(decimals, BTC_DECIMALS);
        console.log("Decimals", decimals);
    }
}
