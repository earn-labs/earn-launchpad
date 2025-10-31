// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

interface IFeeManager {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitted when the protocol fee is updated
    event ProtocolFeeSet(uint256 newProtocolFee);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Set the protocol fee in basis points
    /// @param newProtocolFee New protocol fee in basis points
    function setProtocolFee(uint256 newProtocolFee) external;

    /// @notice Get the current protocol fee in basis points
    /// @return protocolFee Current protocol fee in basis points
    function getProtocolFee() external view returns (uint256 protocolFee);

    /// @notice Withdraw accumulated fees to a specified address
    /// @param to Address to withdraw fees to
    function withdrawFees(address to) external;
}
