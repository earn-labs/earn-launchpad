// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

interface ILiquidityPoolAdapter {
    /// @notice Deploy liquidity to the specified DEX pool
    function deployLiquidity(address tokenA, address tokenB, uint256 amountA, uint256 amountB, bytes memory data)
        external;
}
