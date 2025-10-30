// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {SimpleToken} from "src/tokens/SimpleToken.sol";
import {ITokenFactory} from "src/interfaces/ITokenFactory.sol";

contract TokenFactory is ITokenFactory {
    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 private constant INITIAL_SUPPLY = 1_000_000 * 10 ** 18;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Create a new SimpleToken
    function createToken(string memory name, string memory symbol) external returns (address) {
        SimpleToken token = new SimpleToken(name, symbol, INITIAL_SUPPLY);

        emit TokenCreated(address(token), msg.sender);
        return address(token);
    }
}
