// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {ILiquidityPoolAdapter} from "src/interfaces/ILiquidityPoolAdapter.sol";

/// @title Uniswap V3 Liquidity Pool Adapter
/// @notice Adapter to deploy liquidity to Uniswap V3 pools
/// @dev This contract is supposed to be stateless and called via delegate call by the Launch contract
contract UniswapV3Adapter is ILiquidityPoolAdapter {
    address public constant UNISWAP_V3_ROUTER = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Deploy liquidity to Uniswap V3 pool
    function deployLiquidity(address tokenA, address tokenB, uint256 amountA, uint256 amountB, bytes memory data)
        external
        override
    {
        // Implementation for deploying liquidity to Uniswap V3
    }
}
