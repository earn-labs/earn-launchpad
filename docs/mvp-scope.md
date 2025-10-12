## 1. Project Overview
EARN Launchpad is a decentralized, multi-chain platform for launching curated, high-quality token projects using the EARN token as the ecosystem’s liquidity and governance backbone.

## 2. Core MVP Features
| Phase | Feature | Description |
|--------|----------|--------------|
| **1. Project setup** | Project submission | Creator submits launch details (description, metadata, funding goal, token address). |
|  | First-stage vetting | Admin reviews and marks project as "vetted" (placeholder for AI/community vetting). |
| **2. Contribution phase** | Funding & contributions | Contributors fund the project in EARN tokens (later auto-swap from native token). |
|  | Progress tracking | Frontend displays funding progress via indexed on-chain data. |
| **3. Completion phase** | Campaign close & distribution | When goal met or deadline passes, contract finalizes and distributes project tokens. |
|  | Liquidity pool creation | Automatically creates LP on DEX with EARN pairing. |
| **4. Backend services** | Indexing & API | Backend indexes events, stores metadata, and serves API to frontend. |
| **5. Security baseline** | | Funds non-custodial, validated contract interactions, no external dependencies. |


## 3. Out of Scope (v1 exclusions)
| Category | Deferred Feature |
|-----------|------------------|
| **AI vetting** | No AI project scoring in MVP. |
| **DAO governance** | No community voting or staking yet. |
| **Cross-chain launches** | One chain only (Base Sepolia). |
| **Rewards / Referrals** | No reward system integration. |
| **Advanced pricing curves** | Fixed pricing model. |
| **Custom Funding Goals** | Fixed funding goals only. |
| **UI polish** | Minimal functional interface only. |

## 4. User Roles
| Role | Capabilities |
|------|---------------|
| **Admin** | Review and vet project submissions. |
| **Project Creator** | Deploy launch contract and define parameters. |
| **Contributor** | Connect wallet, contribute native tokens, and claim distributed tokens after sale. |

## 5. System Overview
- Frontend: Next.js app for user interaction.
- Backend: Node.js service with REST/GraphQL API, indexing contract events, PostgreSQL database.
- Smart Contracts: Solidity contracts for launch mechanics, fund management, and token distribution.

## 6. Technical Constraints
- Must use **EARN token** as funding currency (mock ERC-20 on testnet).  
- Must deploy via **Docker Compose** for local reproducibility.  
- Must run **CI/CD via GitHub Actions**.  
- Must expose a simple **API spec (OpenAPI or Swagger)**. 

## 7. Deliverables
- `/contracts`: Foundry project with deployment scripts.  
- `/backend`: NestJS API connected to Postgres.  
- `/frontend`: Next.js minimal interface.  
- `/docs`: updated architecture diagram + ADR-001 (“Backend Stack Choice”).  
- GitHub Actions pipeline running tests.  

## 8. Validation Focus
The MVP’s primary purpose is to validate:
- Architecture correctness of on/off-chain coordination.
- Security boundaries between contract, backend, and frontend.
- Data consistency through event indexing.
- Usability of the funding and distribution flow.