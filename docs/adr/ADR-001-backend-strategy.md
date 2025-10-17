# ADR-001: Backend Strategy (Launch Registry + Envio Architecture)

**Date:** October 2025  
**Status:** Accepted  
**Related ADRs:** [ADR-002 Metadata Storage](./ADR-002-metadata-storage.md), [ADR-003 Indexing Strategy (Envio)](./ADR-003-indexing-strategy.md)

---

## Context
The MVP v0 of **EARN Launchpad** enables users to:
1. Create ERC-20 tokens with metadata, and  
2. Deploy liquidity pools paired with EARN.

Originally, the MVP planned a full backend (NestJS + Postgres) for event indexing and metadata storage.  
However, with **Envio** providing managed event indexing and **IPFS** handling decentralized storage, a large backend is unnecessary.

Still, the system needs a lightweight way to **link token and liquidity metadata** (two separate IPFS CIDs) and persist minimal launch data.

---

## Decision
Implement a **minimal backend service** called the **Launch Registry API**, responsible only for storing and linking IPFS metadata CIDs and on-chain addresses.

- The backend will be built with **Fastify + SQLite** (later upgradable to Postgres).  
- It exposes minimal REST endpoints (`POST /launches`, `GET /launches`) to record and fetch `{ tokenCID, lpCID, creator, tokenAddress, poolAddress }`.  
- **Envio** will remain the main indexing layer for on-chain events (`TokenCreated`, `LiquidityAdded`).

---

## Rationale
- **Simplicity:** Only handles off-chain linkage and metadata registration.  
- **Scalability:** Can be upgraded or integrated into a larger NestJS backend in MVP v1.  
- **Complementary to Envio:** Envio indexes blockchain events; the Launch Registry maintains off-chain associations.  
- **Data persistence:** Keeps IPFS metadata references persistent even if Envio or frontend resets.

---

## Consequences
- ✅ Minimal backend to maintain and deploy.  
- ✅ Enables consistent metadata linkage for frontend display and indexing.  
- ⚠️ Introduces a small centralized component for metadata references.  
- ⚠️ Requires basic security and uptime management.

---

## Future Direction
In **MVP v1**, the backend may expand into:
- Campaign submissions and approvals.  
- User analytics and AI vetting.  
- DAO-driven governance APIs.  
- Integration with Envio APIs and Postgres DB.

---

## Status
**Accepted – October 2025**
