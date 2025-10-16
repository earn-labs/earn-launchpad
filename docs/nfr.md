# Non-Functional Requirements — MVP v0 (Token Creation & Liquidity Deployment)

## 1. Overview
This document defines the **non-functional requirements (NFRs)** for EARN Launchpad MVP v0.  
It describes the system’s expected quality attributes — performance, scalability, reliability, security, maintainability, and observability — to guide architectural and implementation decisions.

---

## 2. Performance

| ID | Requirement | Metric / Target | Priority |
|----|--------------|----------------|----------|
| **NFR-1** | Backend response time | API endpoints should respond within **< 500 ms** under nominal load (≤ 50 requests/sec). | P2 |
| **NFR-2** | Event indexing latency | On-chain events should be reflected in the database within **≤ 5 s** of block confirmation. | P2 |
| **NFR-3** | Contract deployment throughput | Token + liquidity deployments must succeed within **< 30 s total** from user action to confirmation. | P2 |
| **NFR-4** | Launch gas cost | The gas cost to deploy a token and its liquidity pool must not exceed **0.00025 ETH**. | P2 |
| **NFR-5** | Frontend load | Initial page load under **2 s** on modern desktop browser. | P2 |


---

## 3. Scalability

| ID | Requirement | Metric / Target | Priority |
|----|--------------|----------------|----------|
| **NFR-6** | Concurrent users | Support **100 active creators** performing transactions simultaneously without backend timeout. | P2 |
| **NFR-7** | Event volume | Indexer can process **1 000 contract events/minute** without backlog. | P2 |
| **NFR-8** | Horizontal scaling | Backend and DB must be deployable in containers that can be replicated for load balancing. | P3 |

---

## 4. Reliability / Availability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-9** | Fault tolerance | System must recover from RPC or database outage within 1 minute without manual restart. | P2 |
| **NFR-10** | Transaction durability | Once confirmed on-chain, state must never be overwritten or lost in backend. | P1 |
| **NFR-11** | Error handling | Failed contract calls should return human-readable error messages and not block the UI. | P2 |

---

## 5. Security

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-12** | Non-custodial design | Backend must never hold private keys or user funds. | P1 |
| **NFR-13** | Input validation | All API inputs validated against schema / type definitions. | P2 |
| **NFR-14** | Contract safety | Contracts reviewed with Foundry tests covering 100 % of public functions. | P2 |
| **NFR-15** | Environment secrets | API keys, RPC URLs, and DB credentials stored only in `.env` and not committed. | P1 |
| **NFR-16** | Access control | Only admin wallet can deploy TokenFactory & LiquidityDeployer. | P1 |

---

## 6. Maintainability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-17** | Code quality | ESLint / Prettier / Solhint enforced in CI. | P2 |
| **NFR-18** | Test coverage | ≥ 80 % backend unit-test coverage; all contracts tested. | P2 |
| **NFR-19** | Documentation | Each module includes README + API doc / Swagger auto-generation. | P3 |
| **NFR-20** | ADR process | All architectural decisions tracked under `/docs/adr/`. | P3 |

---

## 7. Observability / Monitoring

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-21** | Logging | Backend logs include timestamp, request ID, user wallet; stored for 7 days. | P3 |
| **NFR-22** | Metrics | Expose Prometheus-compatible endpoint with counters for requests, errors, event lag. | P3 |
| **NFR-23** | Alerts | CI pipeline or uptime monitor triggers Slack / email alert on backend failure. | P1 |

---

## 8. Compliance / Deployment

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-24** | CI / CD | GitHub Actions runs tests → build → deploy automatically on merge to `dev` / `master`. | P2 |
| **NFR-25** | Docker reproducibility | Entire stack (contracts + backend + frontend) must build/run locally via `docker-compose up`. | P3 |
| **NFR-26** | Testnet isolation | All deployments use **Base Sepolia** with isolated EARN token instance. | P1 |

---

## 9. Prioritization

| Priority | Meaning |
|-----------|---------|
| **P1 – Critical** | Must be met for MVP v0 to function (security, correctness). |
| **P2 – High** | Strongly desired for stability (scalability, reliability). |
| **P3 – Medium** | Nice-to-have for DX / monitoring. |

---

## 10. Validation Strategy
Each NFR will be validated through:
- **Automated tests** (CI/CD for code quality and performance metrics)
- **Manual stress tests** for event indexing latency and contract throughput
- **Static analysis** for security and contract safety

---
## 11. References
- `/docs/requirements.md` — Functional Requirements  
- `/docs/mvp-scope.md` — MVP Scope  
- `/docs/adr/ADR-001.md` — Decision Record  
