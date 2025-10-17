# ADR-002: Metadata Storage via IPFS

**Date:** October 2025  
**Status:** Accepted  
**Related ADRs:** [ADR-001 Backend Strategy](./ADR-001-backend-strategy.md), [ADR-003 Indexing Strategy (Envio)](./ADR-003-indexing-strategy.md)

---

## Context
Each launched token project requires off-chain metadata such as:
- Name, symbol, description, logo, and social links.  
- Liquidity pool data (pool address, router, burn status, dev allocation).  

This information should be permanent, decentralized, and easily retrievable by both frontend and indexer.  
Storing it on-chain is too expensive; storing it in a centralized backend breaks decentralization goals.

---

## Decision
Use **IPFS** (via Web3.Storage or NFT.Storage) as the primary storage layer for token and liquidity metadata.

1. Upload token metadata (JSON + logo) to IPFS → `tokenCID`.  
2. Deploy liquidity → collect pool metadata → upload to IPFS → `lpCID`.  
3. Store both CIDs in the Launch Registry backend as a single launch entry.

Contracts emit events referencing the CIDs, enabling Envio to index them.

---

## Rationale
- **Decentralized persistence:** Metadata remains accessible independently of backend uptime.  
- **Cost-efficient:** IPFS upload is free or low-cost.  
- **Interoperable:** Envio and backend can resolve the same CIDs.  
- **Immutable content:** Each upload version is uniquely addressable.

---

## Consequences
- ✅ Eliminates centralized file storage.  
- ✅ Simplifies backend complexity.  
- ⚠️ Metadata updates require re-uploading and generating a new CID.  
- ⚠️ Relies on IPFS pinning via Web3.Storage for availability.

---

## Future Direction
In later milestones:
- Metadata may be cached in backend DB for faster queries.  
- Launch Registry may store multiple versions of CIDs for updates.  
- IPFS may be replaced or supplemented by Arweave or Filecoin for permanent archiving.

---

## Status
**Accepted – October 2025**
