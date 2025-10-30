// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

interface IPricingStrategy {
    /// @notice Calculate tokens out for given funds in
    /// @param fundsIn Amount of funding tokens (EARN) provided
    /// @param state Current strategy state (encoded)
    /// @return tokensOut Amount of launch tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateTokensOut(uint256 fundsIn, bytes memory state)
        external
        view
        returns (uint256 tokensOut, bytes memory newState);

    /// @notice Calculate funds out for given tokens in (inverse operation)
    /// @param tokensIn Amount of launch tokens provided
    /// @param state Current strategy state (encoded)
    /// @return fundsOut Amount of funding tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateFundsOut(uint256 tokensIn, bytes memory state)
        external
        view
        returns (uint256 fundsOut, bytes memory newState);
}
