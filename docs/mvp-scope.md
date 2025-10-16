## 1. Project Overview
EARN Launchpad is a decentralized, multi-chain platform for launching curated, high-quality token projects using the EARN token as the ecosystem’s liquidity and governance backbone. To move fast and validate product market fit (PMF), the MVP will be launched on a single chain (Base) in two phases:

1. MVP v0: Token Creation & Liquidity Deployment (EARN pair)
2. MVP v1: Fundraising Flow (basic contribution + distribution)

## 2. Core MVP Features

- **Basic Frontend**: Next.js app for user interaction, minimal analytics and reporting.
- **Security Baseline**: Non-custodial funds, validated contract interactions, no external dependencies.

### 2.1. MVP v0: Token Creation & Liquidity Deployment
1. **Token Creation**: Simple ERC-20 token creation with metadata (name, symbol, supply).
2. **Liquidity Deployment**: Automatic creation of a liquidity pool (LP) on a DEX (e.g., Uniswap) pairing the new token with EARN.
3. **Frontend**: Minimal interface to create tokens and deploy liquidity pools.

### 2.2. MVP v1: Fundraising Flow
1. **Project Submission**: Creators can submit projects with details (description, funding goal, token address).
2. **Admin Vetting**: Admin reviews and approves projects (placeholder for AI/community vetting).
3. **Contribution Mechanism**: Contributors can fund projects using EARN tokens (later auto-swap from native token).
4. **Progress Tracking**: Frontend displays funding progress and status.
5. **Campaign Closure & Distribution**: Automatic closure of campaigns when goals are met or deadlines pass, with token distribution to contributors.
6. **Frontend Enhancements**: Interface for project submission, contribution, and progress tracking.
7. **Backend Services**: Node.js backend indexing contract events, storing metadata, and serving API to frontend.

## 3. Out of Scope (v1 exclusions)
| Category | Deferred Feature |
|-----------|------------------|
| **AI vetting** | No AI project scoring in MVP. |
| **DAO governance** | No community voting or staking yet. |
| **Cross-chain launches** | One chain only (Base Sepolia). |
| **Custom Token Bridge** | No cross-chain token transfers. |
| **Rewards / Referrals** | No reward system integration. |
| **Advanced pricing curves** | Fixed pricing model. |
| **Custom Funding Goals** | Fixed funding goals only. |
| **UI polish** | Minimal functional interface only. |

## 4. User Roles
| Role | Capabilities |
|------|---------------|
| **Admin (v1)** | Review and vet project submissions. |
| **Project Creator (v0+v1)** | Create Token, define parameters. |
| **Contributor (v1)** | Connect wallet, contribute native tokens, and claim distributed tokens after sale. |

## 5. System Overview
- Frontend: Next.js app for user interaction.
- Backend: Node.js service with REST/GraphQL API, indexing contract events, PostgreSQL database.
- Smart Contracts: Solidity contracts for launch mechanics, fund management, and token distribution.

## 6. Technical Constraints
- Must use **EARN token** as funding currency (mock ERC-20 on testnet).  
- Must deploy via **Docker Compose** for local reproducibility.  
- Must run **CI/CD via GitHub Actions**.  
- Must expose a simple **API spec (OpenAPI or Swagger)**. 

### 6.1 Non-Functional Requirements
- **Security**: No backend custody; only verified contracts interact with EARN and DEX router.
- **Reliability**: Backend gracefully handles missed or out-of-order events.
- **Maintainability**: Modular folder structure for contracts, backend, frontend.
- **Observability**: Basic logs and metrics for backend processes.

## 7. Deliverables
- `/contracts`: Foundry project with deployment scripts.  
- `/backend`: NestJS API connected to Postgres.  
- `/frontend`: Next.js minimal interface.  
- `/docs`: updated architecture diagram + ADR-001 (“Backend Stack Choice”).  
- GitHub Actions pipeline running tests.  

## 8. Success Criteria

### 8.1. Success Criteria for MVP v0
- ✅ Creator can create a new ERC-20 token with metadata.  
- ✅ Liquidity pool is automatically created on DEX with EARN pair.
- ✅ Backend correctly indexes events and exposes them via API.  
- ✅ CI/CD passes and Docker setup runs locally.  

### 8.2. Success Criteria for MVP v1
- ✅ Creator can submit a campaign application
- ✅ Admin can vet and approve the campaign.  
- ✅ After approval, campaign is automatically launched and contributors can fund it using testnet EARN.  
- ✅ Campaign auto-closes and distributes tokens when goal (deadline or funding cap) is met.  
- ✅ Backend correctly indexes events and exposes them via API.  
- ✅ CI/CD passes and Docker setup runs locally.  
- ✅ Documentation and diagrams committed in `/docs`.

## 9. Validation Focus
- MVP v0 validates technical integration with EARN and DEX liquidity creation.
- MVP v1 validates user flow for token fundraising and backend event indexing.