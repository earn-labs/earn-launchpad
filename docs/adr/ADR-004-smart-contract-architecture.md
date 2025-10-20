# ADR-004: Smart Contract Architecture (Launch Instances with Strategy Pattern)

**Date:** October 2025  
**Status:** Accepted  
**Related ADRs:** [ADR-001 Backend Strategy](./ADR-001-backend-strategy.md), [ADR-002 Metadata Storage](./ADR-002-metadata-storage.md), [ADR-003 Indexing Strategy](./ADR-003-indexing-strategy.md)

---

## Context

The EARN Launchpad smart contract system must handle:
1. Token creation and deployment
2. Pre-sale swaps (initially creator buy-in, later public participation)
3. Multiple pricing strategies (fixed price, bonding curves, etc.)
4. Token custody during launch phases
5. Liquidity deployment to Uniswap V3
6. Fee collection and distribution

Early architecture considered separating **SalesManager** (pricing logic) and **LaunchVault** (token custody) into distinct contracts. This introduced several problems:
- **Parameter synchronization:** Passing strategy parameters to shared SalesManager is error-prone
- **State management complexity:** Managing state across two contracts per launch
- **Cross-contract calls:** Increased gas costs and security risks
- **Deployment decision:** Either deploy both per launch (expensive) or share globally (complex state mapping)

---

## Decision

Implement a **per-launch architecture** where each token launch gets its own dedicated **Launch contract** that combines vault and sales functionality, with **pricing strategies injected via the Strategy Pattern**.

### Core Architecture:

1. **LaunchFactory (Singleton)**
   - Entry point for creating new launches
   - Deploys new Launch instances with specified pricing strategy
   - Coordinates with TokenFactory for ERC-20 creation
   - Collects launch fees via FeeManager

2. **Launch (Per-Launch Instance)**
   - One contract deployed per token launch
   - Holds tokens (vault functionality)
   - Manages swaps and pricing (sales functionality)
   - References immutable IPricingStrategy contract
   - Maintains launch-specific state and strategy state
   - Transitions through states: Created → PreSale → Active → Liquidity → Closed

3. **IPricingStrategy (Reusable Contracts)**
   - Interface defining pricing calculation methods
   - Implemented by: FixedPriceStrategy, BondingCurveStrategy, etc.
   - Deployed once, referenced by multiple Launch instances
   - Stateless pricing logic with state passed as parameters

4. **Static Support Contracts (Singletons)**
   - **TokenFactory:** Creates ERC-20 tokens
   - **FeeManager:** Collects and manages platform fees
   - **LiquidityManager:** Deploys liquidity to Uniswap V3 via adapter

---

## Architecture Diagram

```
LaunchFactory (singleton)
    │
    ├──(1)──> Launch (instance) ← - - - FixedPriceStrategy
    │            │                      BondingCurveStrategy
    │            │                      (dashed = references)
    │            ├──> holds tokens (vault)
    │            ├──> manages swaps (sales)
    │            ├──> references IPricingStrategy
    │            └──> takes fees ──> FeeManager ──> fee address
    │
    ├──(2)──> TokenFactory ──> Token Contract (ERC-20)
    │
    └──(3)──> LiquidityManager ──> UniswapV3Adapter ──> Uniswap V3

Multiple Launch instances exist (one per project)
```

---

## Rationale

### ✅ Advantages

1. **Single Source of Truth**
   - All launch-specific state in one contract
   - No synchronization issues between separate contracts
   - Clear ownership and responsibility model

2. **Atomic Operations**
   - Token custody and pricing logic together
   - No cross-contract calls for swap operations
   - Reduced attack surface from external calls

3. **Gas Efficiency**
   - Direct token transfers within same contract
   - No external calls for common operations
   - Minimal proxy pattern (EIP-1167) available for further optimization

4. **Strategy Pattern Benefits**
   - Pricing strategies deployed once and reused across launches
   - Easy to add new strategies without modifying core contracts
   - Strategy code can be audited independently
   - Clear separation of pricing logic from vault logic

5. **Flexible State Management**
   - Strategy state stored as `bytes` allows any data structure
   - Each strategy defines its own state requirements
   - Launch contract doesn't need to understand strategy internals

6. **Developer Experience**
   - Clear contract-per-launch mental model
   - Easy to query and debug specific launches
   - Natural mapping to UI (one launch page = one contract)

7. **Security Isolation**
   - Per-launch contracts prevent cross-contamination
   - Bugs in one launch don't affect others
   - Clear audit boundaries

### ⚠️ Trade-offs

1. **Deployment Cost**
   - Each launch deploys a new contract (~$10-50 depending on chain)
   - **Mitigation:** Can use EIP-1167 minimal proxy pattern (~$2-5)

2. **Strategy Immutability**
   - Strategies are immutable per launch once deployed
   - **Mitigation:** Creator can choose strategy at launch time; future versions can add migration

3. **Contract Size**
   - Combining vault + sales increases bytecode size
   - **Mitigation:** Keep Launch contract minimal, delegate complex logic to strategies

---

## Implementation Details

### IPricingStrategy Interface

```solidity
interface IPricingStrategy {
    /// @notice Calculate tokens out for given funds in
    /// @param fundsIn Amount of funding tokens (EARN) provided
    /// @param state Current strategy state (encoded)
    /// @return tokensOut Amount of launch tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateTokensOut(uint256 fundsIn, bytes memory state) 
        external view returns (uint256 tokensOut, bytes memory newState);
    
    /// @notice Calculate funds out for given tokens in (inverse operation)
    /// @param tokensIn Amount of launch tokens provided
    /// @param state Current strategy state (encoded)
    /// @return fundsOut Amount of funding tokens to receive
    /// @return newState Updated strategy state (encoded)
    function calculateFundsOut(uint256 tokensIn, bytes memory state)
        external view returns (uint256 fundsOut, bytes memory newState);
}
```

### Launch Contract States

```solidity
enum LaunchState {
    Created,      // Just deployed, configuration phase
    PreSale,      // Creator can buy in at initial price
    Active,       // Public can participate in sale
    Liquidity,    // Deploying liquidity to DEX
    Closed        // Launch completed, tokens distributed
}
```

### Strategy Implementations

**FixedPriceStrategy (MVP)**
- Simple 1:1 or fixed ratio pricing
- State: `uint256 price` (tokens per EARN)
- Use case: Creator initial buy-in

**BondingCurveStrategy (Future)**
- Linear or exponential price curves
- State: `(uint256 totalSold, uint256 slope, uint256 intercept)`
- Use case: Public pre-sale with increasing price

---

## Alternatives Considered

### Alternative A: Shared SalesManager with Strategy Parameter
```
LaunchFactory ──> SalesManager (singleton)
                     ├──> mapping(launchId => strategy)
                     └──> mapping(launchId => LaunchVault)
```
**Rejected because:**
- ❌ Error-prone parameter passing for strategy selection
- ❌ Synchronization issues between on-chain and off-chain state
- ❌ Complex state management for multiple launches
- ❌ Higher gas costs for storage mapping lookups
- ❌ Potential for cross-launch contamination

### Alternative B: Separate SalesManager + LaunchVault per Launch
```
LaunchFactory ──> SalesManager (instance)
              └──> LaunchVault (instance)
```
**Rejected because:**
- ❌ Two contracts per launch instead of one
- ❌ Cross-contract calls for every swap operation
- ❌ More complex orchestration between contracts
- ❌ Higher deployment costs (2x contracts)

### Alternative C: Single Global Manager with Mapping-Based State
```
LaunchManager (singleton)
    ├──> mapping(launchId => LaunchData)
    ├──> mapping(launchId => TokenBalance)
    └──> mapping(launchId => IPricingStrategy)
```
**Rejected because:**
- ❌ Complex mapping-based state management
- ❌ Difficult to audit individual launches
- ❌ Potential for cross-launch interference
- ❌ Harder to upgrade individual launches

---

## Consequences

### Positive
- ✅ Clear, auditable architecture with strong isolation
- ✅ Flexible pricing strategy system without core contract changes
- ✅ Simplified state management (no cross-contract coordination)
- ✅ Gas-efficient swaps (no external calls)
- ✅ Easy to add new features per launch (airdrop module, vesting, etc.)

### Negative
- ⚠️ Deployment cost per launch (mitigated by minimal proxy pattern)
- ⚠️ Requires careful initial strategy selection (immutable)
- ⚠️ More contracts to track and index (one per launch)

### Neutral
- 📊 Frontend needs to query multiple Launch instances
- 📊 Indexer (Envio) needs to track Launch creation events
- 📊 Strategy library grows over time (normal evolution)

---

## Future Direction

### Phase 1: MVP (Current)
- Implement LaunchFactory + Launch with IPricingStrategy interface
- Deploy FixedPriceStrategy for creator buy-in
- Integrate with TokenFactory and LiquidityManager
- Basic state transitions (Created → PreSale → Active → Liquidity → Closed)

### Phase 2: Strategy Library
- Implement BondingCurveStrategy (linear and exponential variants)
- Add DutchAuctionStrategy (decreasing price over time)
- Create StrategyFactory for common configurations
- Strategy parameter validation and testing tools

### Phase 3: Advanced Features
- Implement EIP-1167 minimal proxy for gas optimization
- Add strategy migration with governance/timelock
- Built-in airdrop module in Launch contract
- Vesting schedules for creator allocations

### Phase 4: Governance & Upgrades
- DAO-controlled strategy whitelist
- Governance-approved strategy upgrades
- Launch parameter templates
- Emergency pause mechanisms

---

## Testing Strategy

1. **Unit Tests (Foundry)**
   - Launch contract state transitions
   - Strategy calculations (FixedPrice, BondingCurve)
   - Fee collection and distribution
   - Token custody and transfers

2. **Integration Tests**
   - Full launch lifecycle (create → swap → liquidity)
   - LaunchFactory coordination with static contracts
   - Multiple launches with different strategies
   - Edge cases (insufficient funds, closed launches)

3. **Invariant Tests**
   - Token balance consistency (custody)
   - Strategy state correctness
   - Fee accounting accuracy
   - Launch state machine validity

4. **Gas Optimization Tests**
   - Swap operation gas costs (<100k target)
   - Deployment costs (standard vs proxy)
   - Batch operations efficiency

---

## Success Metrics

- ✅ Gas cost per swap < 100k gas
- ✅ Deployment cost per launch < $10 (or < $3 with EIP-1167)
- ✅ Zero cross-launch interference bugs in audits
- ✅ Support for 3+ pricing strategies by MVP completion
- ✅ Strategy contracts auditable independently
- ✅ 100% test coverage on Launch and strategy contracts

---

## References

- **Strategy Pattern:** [Refactoring Guru - Strategy Pattern](https://refactoring.guru/design-patterns/strategy)
- **EIP-1167 Minimal Proxy:** [Ethereum Improvement Proposals](https://eips.ethereum.org/EIPS/eip-1167)
- **Bonding Curves:** [Bonding Curves Explained](https://yos.io/2018/11/10/bonding-curves/)
- **Uniswap V3 Integration:** [Uniswap V3 Docs](https://docs.uniswap.org/contracts/v3/overview)

---

## Status
**Accepted – October 2025**

