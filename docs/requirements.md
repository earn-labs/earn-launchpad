# Functional Requirements — MVP v0 (Token Creation & Liquidity Deployment)

## 1. Overview
This document defines functional requirements for **EARN Launchpad MVP v0**, focused on token creation, liquidity deployment, and decentralized metadata persistence.

---

## 2. Scope
Covers:
- Smart contracts for token creation and liquidity deployment  
- IPFS metadata handling  
- Minimal Launch Registry backend  
- Envio indexing and frontend display

Out of scope:
- Fundraising and DAO governance (MVP v1+)

---

## 3. User Roles
| Role | Description |
|------|--------------|
| **Project Creator** | Creates token + liquidity pool and uploads metadata. |
| **Admin** | Optional deployer (no user role in MVP v0). |

---

## 4. Functional Requirements

| ID | Requirement | Description | Acceptance Criteria |
|----|--------------|--------------|--------------------|
| **FR-1** | Token creation | Create ERC-20 token via TokenFactory. | Contract deploys token, emits `TokenCreated`. |
| **FR-2** | Token metadata upload | Upload metadata (JSON + logo) to IPFS. | Returns `tokenCID`. |
| **FR-3** | Liquidity deployment | Deploy liquidity pool (EARN pair). | Emits `LiquidityAdded`. |
| **FR-4** | Liquidity metadata upload | Upload LP metadata (pool address, burn, dev allocation) to IPFS. | Returns `lpCID`. |
| **FR-5** | Launch Registry entry | Store `{ tokenCID, lpCID, creator, addresses }` in backend. | Data persisted via `/launches` API. |
| **FR-6** | Event indexing | Envio indexes events for frontend queries. | Envio GraphQL API reflects event data within 5 s. |
| **FR-7** | UI confirmation | Frontend shows status for uploads + transactions. | User sees success/failure with tx hash. |
| **FR-8** | Data integrity | Token and LP CIDs retrievable and match on-chain events. | Manual verification of CID correlation. |

---

## 5. Dependencies
- **Contracts:** TokenFactory, LiquidityDeployer  
- **Frontend:** Scaffold-ETH 2  
- **Backend:** Fastify Launch Registry (SQLite)  
- **Indexer:** Envio.dev (managed)  
- **Storage:** IPFS via Web3.Storage  
- **Token:** Mock EARN ERC-20

---

## 6. Validation
| FR | Validation Method | Tool |
|----|--------------------|------|
| FR-1–FR-3 | Foundry unit/integration tests | Foundry |
| FR-4–FR-5 | API + IPFS integration tests | Jest / Supertest |
| FR-6 | Envio GraphQL query test | Postman |
| FR-7 | Frontend E2E test | Cypress |

---

## 7. References
- `/docs/mvp-scope.md` — MVP scope and architecture overview  
- `/docs/nfr.md` — Non-functional requirements  
- `/docs/adr/ADR-001–003.md` — Architecture decisions  
- `/docs/diagrams/mvp-v0-sequence.mmd` — Sequence diagram  
