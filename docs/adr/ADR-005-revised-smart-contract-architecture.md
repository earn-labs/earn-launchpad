# ADR-005: Revised Smart Contract Architecture (Access Control & Component Refinements)

**Date:** October 2025  
**Status:** Accepted  
**Related ADRs:** [ADR-001 Backend Strategy](./ADR-001-backend-strategy.md), [ADR-002 Metadata Storage](./ADR-002-metadata-storage.md), [ADR-003 Indexing Strategy](./ADR-003-indexing-strategy.md), [ADR-004 Smart Contract Architecture](./ADR-004-smart-contract-architecture.md)

---

## Context

Following the acceptance of [ADR-004](./ADR-004-smart-contract-architecture.md), further analysis revealed the need for refinements in the smart contract architecture, particularly around:

1. **Access Control Strategy**: How to secure different components and enable future DAO governance
2. **Component Responsibility**: Whether to keep TokenFactory separate or integrate into Launch contracts
3. **Adapter Pattern**: How adapters and strategies should interact with Launch contracts
4. **Deployment Optimization**: Gas efficiency improvements for Launch and Token deployment

The current ADR-004 architecture handles core functionality well, but needs clarification on:
- **Security Model**: Who can create tokens, update fees, and manage system parameters
- **LiquidityManager Redundancy**: The separate LiquidityManager adds complexity without clear benefits
- **Strategy & Adapter Execution**: Whether to use external calls or delegatecalls for maximum gas efficiency

---

## Decision

Refine the ADR-004 architecture with the following key changes:

### 1. Remove LiquidityManager (Architecture Simplification)
**Previous:** LaunchFactory → Launch → LiquidityManager → UniswapV3Adapter  
**Revised:** LaunchFactory → Launch → UniswapV3Adapter (direct)

**Rationale:** LiquidityManager is redundant since Launch contracts already hold tokens and can call adapters directly.

### 2. Implement Comprehensive Access Control
Replace simple ownership patterns with OpenZeppelin `AccessControl` for multi-role governance:

```solidity
// LaunchFactory
bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");

// TokenFactory  
bytes32 public constant LAUNCH_ROLE = keccak256("LAUNCH_ROLE");
bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

// FeeManager
bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
```

### 3. Keep TokenFactory with Restricted Access
**Decision:** Maintain separate TokenFactory but restrict access to authenticated Launch contracts only.

### 4. Optimize Adapter & Strategy Execution
**Adapters:** Use `delegatecall` for stateless operations (gas efficiency)  
**Strategies:** Use `delegatecall` for pricing calculations (gas efficiency)

---

## Architecture Diagram

```
LaunchFactory (singleton) ←──── DAO Governance
    │                              │
    ├──(CREATOR_ROLE)──> Launch (instance) ←─ - - FixedPriceStrategy
    │                      │                     BondingCurveStrategy
    │                      │                     (delegatecall)
    │                      ├──> holds tokens (vault)
    │                      ├──> delegatecall ──> UniswapV3Adapter
    │                      └──> pays fees ──> FeeManager
    │
    ├──(grants LAUNCH_ROLE)─> TokenFactory ──> Token Contract (ERC-20)
    │                            │
    └────────────────────────────┘
                            (LAUNCH_ROLE required)

Access Control Flow:
1. DAO controls ADMIN_ROLE across all contracts
2. LaunchFactory grants LAUNCH_ROLE to new Launch instances  
3. Only LAUNCH_ROLE can create tokens via TokenFactory
4. CREATOR_ROLE can create launches (initially open, later restricted)
```

---

## Rationale

### ✅ Advantages of Revised Architecture

1. **Enhanced Security**
   - Controlled token creation (only through proper Launch process)
   - Multi-role governance ready for DAO transition
   - Clear separation of administrative vs operational roles

2. **Simplified Architecture**
   - Removed redundant LiquidityManager component
   - Direct adapter calls from Launch contracts
   - Cleaner contract interaction patterns

3. **Gas Optimization**
   - `delegatecall` to adapters and strategies (no external call overhead)
   - CREATE2 token deployment for predictable addresses
   - OpenZeppelin Clones for Launch deployment

4. **Future-Proof Governance**
   - AccessControl roles enable smooth DAO transition
   - Granular permissions for different operations
   - Emergency controls and upgrades possible

### ⚠️ Trade-offs

1. **TokenFactory Complexity**
   - Additional access control logic increases deployment cost
   - Role management adds operational overhead

2. **Delegatecall Risks**
   - Adapters must be carefully audited (storage layout conflicts)
   - Strategy contracts need strict validation

---

## Component Specifications

### LaunchFactory (Revised)
```solidity
contract LaunchFactory is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant CREATOR_ROLE = keccak256("CREATOR_ROLE");
    
    // Initially open, later restricted to CREATOR_ROLE
    function createLaunch(LaunchConfig memory config) external returns (address);
    
    // Grants LAUNCH_ROLE to newly created Launch instance
    function _afterLaunchCreation(address launch) internal;
}
```

### TokenFactory (Secured)
```solidity
contract TokenFactory is AccessControl {
    bytes32 public constant LAUNCH_ROLE = keccak256("LAUNCH_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    modifier onlyLaunch() {
        require(hasRole(LAUNCH_ROLE, msg.sender), "Only Launch contracts");
        _;
    }
    
    function createToken(string memory name, string memory symbol) 
        external 
        onlyLaunch 
        returns (address);
}
```

### Launch (Enhanced)
```solidity
contract Launch is Initializable {
    // Direct adapter calls via delegatecall
    function deployLiquidity() external {
        // delegatecall to UniswapV3Adapter for gas efficiency
        (bool success,) = liquidityAdapter.delegatecall(
            abi.encodeWithSignature("deployLiquidity(...)")
        );
    }
    
    // Direct strategy calls via delegatecall  
    function getCurrentPrice() external view returns (uint256) {
        // delegatecall to pricing strategy
    }
}
```

### FeeManager (Multi-Role)
```solidity
contract FeeManager is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");
    
    function setProtocolFee(uint256 newFee) external onlyRole(ADMIN_ROLE);
    function withdrawFees(address to) external onlyRole(TREASURY_ROLE);
}
```

---

## Access Control Matrix

| Contract | Role | Permissions | Initial Holder | Future Holder |
|----------|------|-------------|----------------|---------------|
| LaunchFactory | ADMIN_ROLE | Update implementation, manage roles | Deployer | DAO |
| LaunchFactory | CREATOR_ROLE | Create launches | None (open) | Whitelisted creators |
| TokenFactory | ADMIN_ROLE | Update implementation | Deployer | DAO |
| TokenFactory | LAUNCH_ROLE | Create tokens | Launch contracts | Launch contracts |
| FeeManager | ADMIN_ROLE | Set fees, manage roles | Deployer | DAO |
| FeeManager | TREASURY_ROLE | Withdraw fees | Deployer | DAO Treasury |

---

## Implementation Strategy

### Phase 1: Access Control Implementation
1. **Update existing contracts** with AccessControl inheritance
2. **Deploy role-managed TokenFactory** with LAUNCH_ROLE restrictions
3. **Modify LaunchFactory** to grant LAUNCH_ROLE to new Launch instances
4. **Test role-based permissions** across all components

### Phase 2: Architecture Simplification  
1. **Remove LiquidityManager** references from Launch contracts
2. **Implement direct adapter calls** via delegatecall pattern
3. **Update strategy execution** to use delegatecall
4. **Gas optimization testing** and benchmarking

### Phase 3: Deployment Optimization
1. **Implement CREATE2** for predictable token addresses
2. **Optimize Launch cloning** with minimal proxy pattern
3. **Assembly optimizations** for high-frequency operations

### Phase 4: DAO Transition Preparation
1. **Governance contract development** for role management
2. **Timelock implementation** for sensitive operations  
3. **Emergency pause mechanisms** across all contracts
4. **Role transfer procedures** from deployer to DAO

---

## Security Considerations

### Access Control Risks
- **Role escalation:** Ensure proper role hierarchy and restrictions
- **Single point of failure:** ADMIN_ROLE holders must be secured (multisig)
- **Role transfer safety:** Implement proper handover procedures

### Delegatecall Risks  
- **Storage collision:** Adapters and strategies must not conflict with Launch storage
- **Malicious adapters:** Only trusted, audited adapters should be used
- **Upgrade safety:** Strategy and adapter upgrades need governance approval

### Mitigations
- **Comprehensive testing:** Unit, integration, and invariant tests for all access patterns
- **Audit requirements:** All adapters and strategies must be professionally audited
- **Gradual rollout:** Role restrictions implemented progressively (start open, add restrictions)

---

## Testing Strategy

### Access Control Tests
1. **Role-based function access** - Ensure proper restrictions
2. **Role management** - Grant/revoke roles correctly  
3. **Cross-contract authentication** - TokenFactory only serves Launch contracts
4. **Unauthorized access prevention** - All restricted functions properly protected

### Architecture Tests
1. **Delegatecall functionality** - Adapters and strategies work correctly
2. **Gas consumption** - Delegatecalls vs external calls comparison
3. **Storage safety** - No storage conflicts in delegatecalls
4. **Launch lifecycle** - Full end-to-end testing without LiquidityManager

---

## Success Metrics

- ✅ **Security:** Zero unauthorized access in audit findings
- ✅ **Gas Efficiency:** <15% overhead from access control mechanisms  
- ✅ **Architecture:** 20% reduction in deployment gas from LiquidityManager removal
- ✅ **Governance:** Smooth DAO role transition with zero downtime
- ✅ **Functionality:** All ADR-004 features preserved with enhanced security

---

## Consequences

### Positive
- ✅ **Enhanced Security:** Comprehensive access control ready for DAO governance
- ✅ **Simplified Architecture:** Removal of redundant LiquidityManager component
- ✅ **Gas Optimization:** Delegatecall pattern for adapters and strategies
- ✅ **Controlled Token Creation:** Only authenticated Launch contracts can create tokens
- ✅ **Future-Proof:** Multi-role system supports complex governance scenarios

### Negative  
- ⚠️ **Increased Complexity:** Access control adds operational overhead
- ⚠️ **Delegatecall Risks:** Requires careful adapter/strategy auditing
- ⚠️ **Role Management:** Initial setup and role transitions need careful handling

### Neutral
- 📊 **Migration Required:** Existing deployments need access control updates
- 📊 **Documentation:** Role management procedures need comprehensive documentation
- 📊 **Tooling:** Frontend needs to handle role-based functionality

---

## References

- **OpenZeppelin AccessControl:** [Access Control Documentation](https://docs.openzeppelin.com/contracts/4.x/access-control)
- **Delegatecall Patterns:** [Solidity Documentation](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html#delegatecall-callcode-and-libraries)
- **CREATE2 Deployment:** [EIP-1014](https://eips.ethereum.org/EIPS/eip-1014)
- **Minimal Proxy Pattern:** [EIP-1167](https://eips.ethereum.org/EIPS/eip-1167)

---

## Status
**Accepted – October 2025**

