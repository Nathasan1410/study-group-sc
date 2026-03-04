// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IERC20} from "@openzeppelin-contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin-contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

contract Vault is ReentrancyGuard {
    using SafeERC20 for IERC20;

    address public token;

    uint256 public totalSupplyShares;
    uint256 public totalSupplyAssets;

    mapping(address => uint256) public userSupplyShares;

    event Deposit(address user, uint256 amount, uint256 shares);
    event Withdraw(address user, uint256 shares, uint256 assets);
    event DistributeReward(uint256 amount, address distributor);

    constructor(address _token) {
        token = _token;
    }

    function deposit(uint256 _amount) public nonReentrant {
        uint256 shares;

        if (totalSupplyShares == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupplyShares) / totalSupplyAssets;
        }

        userSupplyShares[msg.sender] += shares;
        totalSupplyShares += shares;
        totalSupplyAssets += _amount;

        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        emit Deposit(msg.sender, _amount, shares);
    }

    function withdraw(uint256 _shares) public nonReentrant {
        uint256 assets;

        if (totalSupplyShares == 0) {
            assets = _shares;
        } else {
            assets = (_shares * totalSupplyAssets) / totalSupplyShares;
        }

        userSupplyShares[msg.sender] -= _shares;
        totalSupplyShares -= _shares;
        totalSupplyAssets -= assets;

        IERC20(token).safeTransfer(msg.sender, assets);

        emit Withdraw(msg.sender, _shares, assets);
    }

    function distributeReward(uint256 _amount) public nonReentrant {
        totalSupplyAssets += _amount;
        IERC20(token).safeTransferFrom(msg.sender, address(this), _amount);

        emit DistributeReward(_amount, msg.sender);
    }
}
