// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.26;

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {SimpleToken, IERC20} from "src/tokens/SimpleToken.sol";
import {ILiquidityPoolAdapter} from "src/interfaces/ILiquidityPoolAdapter.sol";
import {IPricingStrategy} from "src/interfaces/IPricingStrategy.sol";
import {ITokenFactory} from "src/interfaces/ITokenFactory.sol";
import {ILaunch} from "src/interfaces/ILaunch.sol";

contract Launch is ILaunch, Initializable {
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    LaunchConfig private s_config;
    LaunchState private s_state;

    string private s_name;
    string private s_symbol;
    address private s_creator;

    address private s_pricingStrategy;
    address private s_tokenFactory;
    address private s_liquidityPoolAdapter;

    address private s_tokenAddress;
    address private s_baseAddress;

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor() {
        _disableInitializers();
    }

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function initialize(LaunchConfig memory launchConfig) external initializer {
        // launch parameters
        // - private or public: whitelisted participants (creator is whitelisted automatically for dev buyin) or public sale
        // - pricing strategy: fixed price, bonding curve, dutch auction
        // - soft cap / hard cap
        // - dex to deploy liquidity to
        // - liquidity percentage to add to DEX
        // - presale duration
    }

    function createToken() external {
        // can only be called once
        (string memory name, string memory symbol,) = abi.decode(s_config.tokenData, (string, string, uint256));
        s_tokenAddress = ITokenFactory(s_tokenFactory).createToken(name, symbol);
        s_state = LaunchState.PreSale;
    }

    function swapTokens() external payable {
        // can only be called while in PreSale state
        // Logic for participants to swap ETH for tokens
    }

    function deployLiquidity() external {
        // can only be called when Presale ended
        uint256 tokenAmount = IERC20(s_tokenAddress).balanceOf(address(this));
        uint256 baseAmount = IERC20(s_baseAddress).balanceOf(address(this));

        ILiquidityPoolAdapter(s_liquidityPoolAdapter).deployLiquidity(
            s_tokenAddress, s_baseAddress, tokenAmount, baseAmount, ""
        );
        s_state = LaunchState.Closed;
    }

    function emergencyWithdraw() external {
        // allow participants to withdraw their funds if launch fails
    }

    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

    /// @notice Get current launch state
    function getState() external view returns (LaunchState) {
        return s_state;
    }

    // @notice Get current price per token
    function getCurrentPrice() external view returns (uint256) {
        // TODO: implement
    }

    /// @notice Get launch creator
    function getCreator() external view returns (address) {
        return s_creator;
    }

    /// @notice Get token address (available after creation)
    function getToken() external view returns (address) {
        return s_tokenAddress;
    }
}
