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
| **FR-1** | Token creation | The system must allow a user to create a new ERC-20 token with parameters (name, symbol, description, logo image, socials) and flat-rate liquidity and operations (0.01 ETH). | When the user submits the form, a token is deployed with fixed supply on-chain via the TokenFactory contract, and its address is returned. |
| **FR-2** | Token metadata persistence | The backend must store token metadata (creator address, token address, parameters, timestamp, verification status). | After token creation, metadata is verified on-chain and the backend API persists the metadata and serves it through `/api/tokens`. |
| **FR-3** | Liquidity deployment | The system must automatically create a Uniswap V3 liquidity pool for the new token and EARN token pair. | When the user submits the form and token is created, a LiquidityDeployer contract call succeeds and emits a PoolCreated event. |
| **FR-4** | Liquidity Burn | Liquidity must automatically be burned. | After liquidity pool is created, the liquidity is automatically burned, emitting a LiquidityBurned event. |
| **FR-5** | LP metadata persistence | The backend must store liquidity pool metadata (token pair, pool address, amounts, burn status). | Data is saved in the database and available via `/api/liquidity`. |
| **FR-6** | Dev Buy In | The system must allow the user to specify a dev buy-in amount to purchase tokens pre-launch. The tokens must be airdropped to user wallet and add buy-in amount to LP | LiquidityDeployer contract call executes the swap and emits a DevBuyIn event. |
| **FR-7** | Dev metadata persistence | The backend must store dev buy-in metadata (user address, token address, amounts). | Data is saved in the database and available via `/api/dev`. |
| **FR-8** | Transaction feedback | The frontend must display transaction status (pending, confirmed, failed). | User sees progress feedback and final confirmation after contract events are indexed. |
| **FR-9** | Data synchronization | The backend must index on-chain events for created tokens and liquidity pools. | After each transaction, events are fetched, stored, and reflected in frontend API responses. |
| **FR-10** | Contract Verification | The backend must verify contract deployment on chain with blockscan. | Contract verification status of blockscan returns "verified". |
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
- **Frontend:** ETH-Scaffold-2 (Next.js)  
- **External:** EARN token deployed on testnet

---

## 9. Validation & Test Mapping
| FR | Validation Method | Tool |
|----|--------------------|------|
| FR-1–FR-4 | Smart contract unit & integration tests | Foundry |
| FR-5–FR-7 | API integration tests | Jest / Supertest |
| FR-8 | Frontend E2E tests | Cypress |
| FR-9–FR-11 | Backend indexing & verification tests | Postman / Manual QA |

---

## 8. References
- `/docs/mvp-scope.md` – defines overall MVP phases and features.  
- `/docs/diagrams/mvp-v0-flow.excalidraw` – architecture flow for token creation and liquidity deployment.  
- `/contracts/src/TokenFactory.sol` – contract implementing FR-1.  
- `/contracts/src/LiquidityDeployer.sol` – contract implementing FR-3, FR-4, FR-6.

