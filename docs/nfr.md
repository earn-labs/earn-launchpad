# Non-Functional Requirements — MVP v0 (Token Creation & Liquidity Deployment)

## 1. Overview
This document defines quality attributes for EARN Launchpad MVP v0, reflecting the hybrid architecture using:
- IPFS for metadata storage  
- Envio for indexing  
- Minimal Launch Registry backend (Fastify + SQLite)

---

## 2. Performance

| ID | Requirement | Target | Priority |
|----|--------------|--------|----------|
| **NFR-1** | Launch Registry response time | < 500 ms for CID lookups | P2 |
| **NFR-2** | Envio indexing latency | ≤ 5 s after block confirmation | P2 |
| **NFR-3** | IPFS upload latency | ≤ 3 s for 100 KB metadata bundle | P2 |
| **NFR-4** | Token + LP deployment | ≤ 30 s total transaction time | P2 |
| **NFR-5** | Frontend load time | < 2 s on modern browsers | P2 |

---

## 3. Scalability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-6** | Concurrent users | 100 creators simultaneously deploying tokens | P2 |
| **NFR-7** | Envio throughput | Handle 1,000 events/min without delay | P2 |
| **NFR-8** | Backend replication | Launch Registry deployable as stateless container | P3 |

---

## 4. Reliability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-9** | Fault tolerance | System recovers from RPC/IPFS outage within 1 min | P2 |
| **NFR-10** | Idempotent writes | Backend ignores duplicate CIDs and tx hashes | P1 |
| **NFR-11** | Event consistency | Envio + backend data consistent via CID + address correlation | P1 |

---

## 5. Security

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-12** | Non-custodial | Backend stores no funds/private keys | P1 |
| **NFR-13** | IPFS validation | Uploaded files restricted to valid MIME types | P2 |
| **NFR-14** | Access control | Only authorized wallet can deploy contracts | P1 |
| **NFR-15** | Secrets management | `.env` for all API keys and RPCs | P1 |

---

## 6. Maintainability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-16** | Code quality | ESLint / Solhint / Prettier enforced | P2 |
| **NFR-17** | Test coverage | ≥ 80 % smart contract & backend tests | P2 |
| **NFR-18** | Documentation | ADRs and API specs maintained in `/docs` | P3 |

---

## 7. Observability

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-19** | Logging | Envio + backend logs timestamped and persisted 7 days | P3 |
| **NFR-20** | Metrics | Prometheus-compatible endpoint for backend | P3 |
| **NFR-21** | Alerts | CI/CD failure or backend downtime triggers Slack/email | P1 |

---

## 8. Deployment

| ID | Requirement | Description | Priority |
|----|--------------|-------------|----------|
| **NFR-22** | CI/CD | GitHub Actions runs test → build → deploy | P2 |
| **NFR-23** | Docker reproducibility | All services run under `docker-compose up` | P2 |
| **NFR-24** | Testnet | Base Sepolia with mock EARN token | P1 |

---

## 9. Validation
- Unit + integration tests (contracts + backend)
- Manual latency test for Envio indexing
- IPFS upload timing test
- Continuous monitoring via CI logs
