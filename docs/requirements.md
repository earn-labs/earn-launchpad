# Functional Requirements — MVP v0 (Token Creation & Liquidity Deployment)

## 1. Overview
This document defines the **functional requirements** for the MVP v0 of the EARN Launchpad — focusing exclusively on the two core user actions:
1. Token creation  
2. Liquidity deployment

These requirements describe what the system must do from the user’s and system’s perspective, without prescribing technical implementation details.

---

## 2. Scope
This document covers:
- Smart contract functionality for token creation and liquidity deployment.
- Backend API behaviors directly related to these flows.
- Frontend interactions required to trigger and monitor these actions.

Out of scope:
- Project vetting, fundraising, or distribution flows (deferred to MVP v1+).

---

## 3. User Roles
| Role | Description |
|------|--------------|
| **Creator** | User who creates a token and deploys liquidity. |
| **Contributor** | Not relevant for MVP v0 (excluded). |
| **Admin** | Optional; may deploy the system but not part of user flow. |

---

## 4. Functional Requirements

| ID | Requirement | Description | Acceptance Criteria |
|----|--------------|--------------|--------------------|
| **FR-1** | Token creation | The system must allow a user to create a new ERC-20 token with parameters (name, symbol, supply, decimals). | When the user submits the form, a token is deployed on-chain via the TokenFactory contract, and its address is returned. |
| **FR-2** | Token metadata persistence | The backend must store token metadata (creator address, token address, parameters, timestamp). | After token creation, the backend API persists the metadata and serves it through `/api/tokens`. |
| **FR-3** | Liquidity deployment | The system must allow the user to create a liquidity pool using the created token and EARN token pair. | When the user specifies token amount + EARN amount, a LiquidityDeployer contract call succeeds and emits a PoolCreated event. |
| **FR-4** | LP metadata persistence | The backend must store liquidity pool metadata (token pair, pool address, amounts). | Data is saved in the database and available via `/api/liquidity`. |
| **FR-5** | Transaction feedback | The frontend must display transaction status (pending, confirmed, failed). | User sees progress feedback and final confirmation after contract events are indexed. |
| **FR-6** | Data synchronization | The backend must index on-chain events for created tokens and liquidity pools. | After each transaction, events are fetched, stored, and reflected in frontend API responses. |

---

## 5. Future Deferred Functionalities
These will be part of later MVP versions:
- Fundraising and distribution logic (MVP v1).
- Multi-chain support.
- Governance or DAO integration.

---

## 6. Dependencies
- **Smart Contracts:** TokenFactory, LiquidityDeployer  
- **Backend Services:** API server (NestJS), PostgreSQL database  
- **Frontend:** Next.js with wallet connection (Wagmi / ethers.js)  
- **External:** EARN token deployed on testnet

---

## 7. Open Questions
- What type of liquidity deployment should occur (PancakeSwap or Uniswap, V2, V3, or V4)?
- Should backend verify on-chain deployment success before storing metadata?  
- Should tokens be verified via block explorer in pipeline?

---

## 8. References
- `/docs/mvp-scope.md` – defines overall MVP phases and features.  
- `/docs/diagrams/mvp-v0-flow.excalidraw` – architecture flow for token creation and liquidity deployment.  
- `/contracts/src/TokenFactory.sol` – contract implementing FR-1.  
- `/contracts/src/LiquidityDeployer.sol` – contract implementing FR-3.
