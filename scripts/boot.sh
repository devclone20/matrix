#!/usr/bin/env bash
# matrix — boot the agent with this project's SKILLS trusted.
# Hermes injects this project's AGENTS.md on every session with no trust step — that
# file carries the soul. (A repo-root SOUL.md is never injected; Hermes reads SOUL.md
# only from ~/.hermes/SOUL.md, the owner's global soul, which this script never writes.)
# Trust is only for project skills: `hermes skills trust` lets Hermes discover
# .hermes/skills, and it persists. Extra args pass through to `hermes chat`.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v hermes >/dev/null 2>&1; then
  echo "✗ 'hermes' not found. Run: bash scripts/setup.sh"
  echo "  (or install directly: curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash)"
  exit 1
fi

hermes skills trust "$PWD" >/dev/null 2>&1 || true
exec hermes chat "$@"
