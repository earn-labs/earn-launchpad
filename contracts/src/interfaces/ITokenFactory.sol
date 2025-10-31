// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

interface ITokenFactory {
    // Notes:
    // (1) who should be the creator?

    /// @notice Emitted when a new token is created
    event TokenCreated(address indexed tokenAddress, address indexed creator);

    /// @notice Create a new ERC20 token
    /// @param name Name of the token
    /// @param symbol Symbol of the token
    /// @return tokenAddress Address of the newly created token
    function createToken(string memory name, string memory symbol) external returns (address tokenAddress);
}
