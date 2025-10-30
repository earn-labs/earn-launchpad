// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

interface ILaunch {
    /*//////////////////////////////////////////////////////////////
                                 TYPES
    //////////////////////////////////////////////////////////////*/
    /// @notice Current state of the launch lifecycle
    enum LaunchState {
        Created, // Just deployed, configuration phase
        PreSale, // Creator can buy in at initial price
        Active, // Public can participate in sale
        Liquidity, // Deploying liquidity to DEX
        Closed // Launch completed, tokens distributed

    }

    /// @notice Parameters for token creation
    struct TokenConfig {
        string name;
        string symbol;
        string metadataCID;
    }

    /// @notice Parameters for launch configuration
    struct LaunchConfig {
        uint256 softCap;
        uint256 hardCap;
        uint256 presaleDuration;
        bool isPrivate;
        address adapter;
        address pricingStrategy;
        bytes strategyData;
        bytes tokenData;
    }

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event TokenCreated(address indexed token, address indexed creator);
    event StateChanged(LaunchState indexed newState);
    event TokensPurchased(address indexed buyer, uint256 ethIn, uint256 tokensOut);
    event LiquidityDeployed(address indexed pool, uint256 tokenAmount, uint256 ethAmount);

    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
    error InvalidState(LaunchState current, LaunchState required);
    error UnauthorizedCaller(address caller);
    error InsufficientFunds(uint256 required, uint256 provided);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Initialize the launch with token and launch parameters
    function initialize(LaunchConfig memory launchConfig) external;

    /// @notice Create the token and move to PreSale state
    function createToken() external;

    /// @notice Swap ETH for tokens during sale
    function swapTokens() external payable;

    /// @notice Deploy liquidity to DEX and close launch
    function deployLiquidity() external;

    /// @notice Withdraws all funds in case of emergency
    function emergencyWithdraw() external;

    /// @notice Get current launch state
    function getState() external view returns (LaunchState);

    // @notice Get current price per token
    function getCurrentPrice() external view returns (uint256);

    /// @notice Get launch creator
    function getCreator() external view returns (address);

    /// @notice Get token address (available after creation)
    function getToken() external view returns (address);
}
