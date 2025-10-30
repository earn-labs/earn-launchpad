// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {IPricingStrategy} from "src/interfaces/IPricingStrategy.sol";

contract FixedPriceStrategy is IPricingStrategy {
    uint256 public immutable pricePerToken; // Price in funding tokens (EARN) per launch token

    // TODO
    // this doesn't work like this. the fixed price strategy needs to be parameterized somehow to allow different prices per launch.
    constructor(uint256 _pricePerToken) {
        pricePerToken = _pricePerToken;
    }

    /// @notice Calculate tokens out for given funds in
    /// @param fundsIn Amount of funding tokens (EARN) provided
    /// @param state Current strategy state (encoded)
    /// @return tokensOut Amount of launch tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateTokensOut(uint256 fundsIn, bytes memory state)
        external
        view
        override
        returns (uint256 tokensOut, bytes memory newState)
    {
        tokensOut = fundsIn / pricePerToken;
        newState = state; // No state change for fixed price
    }

    /// @notice Calculate funds out for given tokens in (inverse operation)
    /// @param tokensIn Amount of launch tokens provided
    /// @param state Current strategy state (encoded)
    /// @return fundsOut Amount of funding tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateFundsOut(uint256 tokensIn, bytes memory state)
        external
        view
        override
        returns (uint256 fundsOut, bytes memory newState)
    {
        fundsOut = tokensIn * pricePerToken;
        newState = state; // No state change for fixed price
    }
}
