// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import {ILaunch} from "src/interfaces/ILaunch.sol";

interface ILaunchFactory {
    /// @notice Emitted when a new Launch contract is created
    event LaunchCreated(address indexed launchAddress, address indexed creator);

    /// @notice Create a new Launch contract
    function createLaunch(ILaunch.LaunchConfig memory launchConfig) external returns (address);
}
