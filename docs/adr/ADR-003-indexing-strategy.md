# ADR-003: Indexing Strategy (Envio)

**Date:** October 2025  
**Status:** Accepted  
**Related ADRs:** [ADR-001 Backend Strategy](./ADR-001-backend-strategy.md), [ADR-002 Metadata Storage](./ADR-002-metadata-storage.md)

---

## Context
EARN Launchpad smart contracts emit multiple events:
- `TokenCreated` (token deployed)
- `LiquidityAdded` (LP created)
- Future: `CampaignCreated`, `ContributionAdded`, etc.

The frontend must display these events in real time, and the system must maintain an indexed view of all launches.  
A traditional backend indexer would require custom event listeners and a database.

---

## Decision
Adopt **Envio.dev** as the managed event indexer and API provider.

- Envio subscribes to contract events, normalizes them into entities, and exposes a **GraphQL API** for queries.  
- The frontend consumes this API directly to display launched tokens and liquidity pools.  
- The Launch Registry backend stores additional off-chain metadata references (IPFS CIDs) complementary to Envio’s indexed on-chain data.

---

## Rationale
- **No custom indexer:** Offloads event listening and data persistence.  
- **Instant GraphQL/REST endpoints:** Ready to query after deployment.  
- **Real-time updates:** Envio supports subscriptions for live UI updates.  
- **Modular integration:** Backend and frontend both consume Envio APIs.
- **Simplicity:** Available as an extension for Scaffold-ETH-2.

---

## Consequences
- ✅ Removes need for custom backend event listeners.  
- ✅ Provides reliable event indexing and querying.  
- ⚠️ Introduces dependency on Envio’s hosted service (availability, API limits).  
- ⚠️ Requires schema maintenance (entity definitions and versioning).

---

## Future Direction
In future releases:
- Backend analytics and DAO governance modules will consume Envio’s API.  
- Envio entities may expand to include Campaigns, Contributions, and Vetting votes.  
- Option to self-host Envio indexer for complete decentralization.

---

## Status
**Accepted – October 2025**
