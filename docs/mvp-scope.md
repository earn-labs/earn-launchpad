## 1. Project Overview
EARN Launchpad is a decentralized, multi-chain platform for launching curated, high-quality token projects using the EARN token as the ecosystem’s liquidity and governance backbone.  
To move fast and validate product-market fit (PMF), the MVP will be launched on a single chain (Base) in two phases:

1. **MVP v0:** Token Creation & Liquidity Deployment (EARN pair)  
2. **MVP v1:** Fundraising Flow (basic contribution + distribution)

---

## 2. Core MVP Features

- **Frontend:** Scaffold-ETH 2 (Next.js + wagmi) app for wallet connection, transaction flow, and event visualization.  
- **Security Baseline:** Non-custodial, validated contract interactions, minimal trusted components.  
- **Data Layer:** Decentralized metadata on IPFS, on-chain event indexing via Envio, and a minimal Launch Registry backend linking CIDs.

### 2.1. MVP v0: Token Creation & Liquidity Deployment
1. **Token Creation:** Simple ERC-20 token creation with metadata (name, symbol, description, logo, socials) uploaded to IPFS.  
2. **Liquidity Deployment:** Automatic creation of a liquidity pool (LP) on a DEX (e.g., Uniswap) pairing the new token with EARN.  
3. **Launch Registry Backend:** Minimal Fastify/SQLite API storing relationships between token and liquidity metadata (IPFS CIDs, addresses, tx hashes).  
4. **Indexing Layer:** Envio indexes on-chain events (`TokenCreated`, `LiquidityAdded`) and exposes them via GraphQL.  
5. **Frontend:** Scaffold-ETH 2 UI interacts with contracts, IPFS, Envio, and the Launch Registry backend.

### 2.2. MVP v1: Fundraising Flow
1. **Project Submission:** Creators can submit projects with details (description, funding goal, token address).  
2. **Admin Vetting:** Admin reviews and approves projects (placeholder for AI/community vetting).  
3. **Contribution Mechanism:** Contributors fund projects using EARN tokens.  
4. **Progress Tracking:** Frontend displays funding progress via Envio-indexed data.  
5. **Campaign Closure & Distribution:** Automatic closure and token distribution to contributors.  
6. **Backend Expansion:** Launch Registry evolves into a full backend (NestJS + Postgres) integrating Envio APIs and analytics.

---

## 3. Out of Scope (v1 exclusions)
| Category | Deferred Feature |
|-----------|------------------|
| **AI vetting** | No AI project scoring in MVP. |
| **DAO governance** | No community voting or staking yet. |
| **Cross-chain launches** | One chain only (Base Sepolia). |
| **Rewards / Referrals** | No reward system integration. |
| **Advanced pricing curves** | Fixed pricing model. |
| **UI polish** | Minimal functional interface only. |

---

## 4. User Roles
| Role | Capabilities |
|------|---------------|
| **Admin (v1)** | Review and vet project submissions. |
| **Project Creator (v0+v1)** | Create token, upload metadata to IPFS, deploy liquidity, submit projects. |
| **Contributor (v1)** | Contribute EARN tokens and claim distribution after sale. |

---

## 5. System Overview
- **Frontend:** Scaffold-ETH 2 app (Next.js + wagmi + viem).  
- **Backend:** Launch Registry API (Fastify + SQLite) storing token + LP metadata CIDs.  
- **Indexing Layer:** Envio indexing smart-contract events, exposing GraphQL API.  
- **Storage:** IPFS (Web3.Storage) for token & liquidity metadata JSON and assets.  
- **Smart Contracts:** Foundry contracts for token factory and liquidity deployer.

---

## 6. Technical Constraints
- Use **EARN token** as funding currency (mock ERC-20 on Base Sepolia).  
- Deploy via **Docker Compose**.  
- Use **GitHub Actions CI/CD**.  
- Maintain **Envio schema definitions** under `/envio`.  
- Expose Launch Registry API via **OpenAPI**.

---

### 6.1. Non-Functional Requirements
- **Security:** Non-custodial, backend stores metadata only (no keys/funds).  
- **Reliability:** Frontend retries transactions using cached IPFS CIDs; backend handles idempotent CID writes.  
- **Maintainability:** Modular repo (`contracts`, `frontend`, `backend`, `envio`).  
- **Observability:** Basic logs for backend and Envio indexing latency.

---

## 7. Deliverables
- `/contracts`: Foundry project for token + liquidity deployment.  
- `/frontend`: Scaffold-ETH 2 interface.  
- `/backend`: Launch Registry API (Fastify + SQLite).  
- `/envio`: Schema + config for event indexing.  
- `/docs`: Updated diagrams + ADRs 001–003.  
- CI/CD pipeline in GitHub Actions.

---

## 8. Success Criteria

### 8.1. MVP v0
- ✅ Creator can create token + upload metadata to IPFS.  
- ✅ Liquidity pool auto-created on DEX with EARN pair.  
- ✅ Launch Registry backend stores `{ tokenCID, lpCID, addresses }`.  
- ✅ Envio indexes `TokenCreated` + `LiquidityAdded` events.  
- ✅ Frontend displays launched projects from Envio + IPFS.  

### 8.2. MVP v1
- ✅ Creator submits project campaign.  
- ✅ Admin vets and approves campaign.  
- ✅ Contributors fund and receive tokens.  
- ✅ Envio indexes campaign events.  
- ✅ Backend integrates analytics and project data.  

---

## 9. Validation Focus
- **MVP v0:** Validate metadata persistence across IPFS, Launch Registry, and Envio indexing.  
- **MVP v1:** Validate campaign lifecycle, backend integration, and system scalability.

---

> **Architecture Decisions:**  
> [ADR-001 (Backend Strategy)](./adr/ADR-001-backend-strategy.md),  
> [ADR-002 (Metadata Storage)](./adr/ADR-002-metadata-storage.md),  
> [ADR-003 (Indexing Strategy – Envio)](./adr/ADR-003-indexing-strategy.md)
