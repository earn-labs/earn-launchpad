// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IFeeManager} from "src/interfaces/IFeeManager.sol";

contract FeeManager is IFeeManager, Ownable {
    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 private constant PRECISION = 10_000;
    uint256 private s_protocolFee = 300; // default to 3%

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(address initialOwner) Ownable(initialOwner) {}

    receive() external payable {}

    /// @notice Set the fee in basis points
    function setProtocolFee(uint256 newProtocolFee) external override onlyOwner {
        s_protocolFee = newProtocolFee;
        emit ProtocolFeeSet(newProtocolFee);
    }

    /// @notice Get the current fee in basis points
    function getProtocolFee() external view override returns (uint256) {
        return s_protocolFee;
    }

    /// @notice Withdraw accumulated fees to a specified address
    /// @param to Address to withdraw fees to
    function withdrawFees(address to) external onlyOwner {}
}
