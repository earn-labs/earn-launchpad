// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ILaunchFactory, ILaunch} from "./interfaces/ILaunchFactory.sol";

contract LaunchFactory is ILaunchFactory, AccessControl {
    // Notes:
    // (1) should this be upgradable or not?

    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");

    address public immutable i_launchImplementation;
    mapping(address launch => ILaunch.LaunchConfig) public s_launches;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address admin, address launchImplementation) {
        i_launchImplementation = launchImplementation;

        _grantRole(ADMIN_ROLE, admin);
    }

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Create a new Launch contract
    function createLaunch(ILaunch.LaunchConfig memory launchConfig) external override returns (address) {
        address launch = Clones.clone(i_launchImplementation);
        ILaunch(launch).initialize(launchConfig);
        emit LaunchCreated(launch, msg.sender);
        return launch;
    }
}
