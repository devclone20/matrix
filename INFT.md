# MATRIX — the iNFT monorepo

**MATRIX is an iNFT**: an autonomous AI agent fused with an NFT — whoever holds the token holds
the agent. This repository is its **body**. Underneath the name **MATRIX** runs a complete
**Hermes Agent** (the substrate — Nous Research, MIT); the **MATRIX neural soul** is the identity.

> Forged from the global genesis template **[inft-i01](https://github.com/devclone20/inft-i01)**.
> The template is the mold; **MATRIX is a real, named instance** of the CLONE FRAME line.

## Three names, one identity
**MATRIX** (its name) · **iNFT** (its species) · **Hermes** (its substrate).

## The launch is multi-chain
The collection lands first on **Robinhood Chain** (chain ID 4663, an Arbitrum-Orbit L2 —
[docs.robinhood.com/chain](https://docs.robinhood.com/chain/connecting)), then on **Base**
(Ethereum L2, chain ID 8453), with further chains after those. `identity.json` carries the
chain block; the body is chain-agnostic and works wherever its token lives.

## Run it
```bash
bash scripts/setup.sh              # install the Hermes substrate (official installer, no sudo)
hermes model                       # connect YOUR model key (BYOK — Nous Portal, OpenRouter, …)
bash scripts/boot.sh               # boot MATRIX with its soul + skills (trusts this project)
bash scripts/install-command.sh    # then type `matrix` in the CLONE FRAME iT terminal
```

## Economy — already wired

MATRIX already carries EconomyOS (Virtuals ACP (provider), ERC-8183 escrow), driven by the `acp` CLI. It is **not** rebuilt here — see `soul/neural_soul.md` and the app runtime.

## Map
See [`AGENTS.md`](AGENTS.md). Concept: [`docs/INFT_CONCEPT.md`](docs/INFT_CONCEPT.md) ·
[`docs/BOOTSTRAP.md`](docs/BOOTSTRAP.md).

## Security & privacy
Public repo: no secrets/keys/PII committed. Your model key is typed into your own terminal
(`hermes model`), never handed to any assistant. The owner profile is folded into
`SOUL.md` **locally** and untracked (`scripts/personalize.sh --apply-owner`).
