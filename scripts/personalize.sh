#!/usr/bin/env bash
# inft-i01 — personalize a forged repo. Idempotent and non-destructive.
#
#   personalize.sh "Agent Name"     Set the marketplace name (won't clobber an
#                                   already-personalized name without --force).
#   personalize.sh --apply-owner    Generate the LOCAL, gitignored AGENTS.override.md
#                                   = tracked AGENTS.md + .hermes/owner.local.md, so
#                                   the owner profile reaches the agent without ever
#                                   being committed.
#   Flags: --force  overwrite an existing name.
#
# Why AGENTS.override.md and not SOUL.md: Hermes injects AGENTS.md from the project on
# every session, and per directory `AGENTS.override.md` wins over `AGENTS.md` — the
# documented way to keep a personal, gitignored override beside the committed file. A
# repo-root SOUL.md is never injected (Hermes reads SOUL.md only from ~/.hermes/SOUL.md,
# the owner's global soul, which this script must never touch). Because the override
# REPLACES AGENTS.md for that directory, it is regenerated from AGENTS.md every run —
# re-run this after editing AGENTS.md.
set -euo pipefail
cd "$(dirname "$0")/.."

PLACEHOLDER="iNFT i01"
SENTINEL="<!-- OWNER-PROFILE-APPLIED -->"

say() { printf '%s\n' "$*"; }

apply_owner() {
  local prof=".hermes/owner.local.md"
  local base="AGENTS.md"
  local target="AGENTS.override.md"
  [ -f "$prof" ] || { say "✗ $prof not found. Write the owner profile there first (see owner/OWNER.example.md)."; exit 1; }
  [ -f "$base" ] || { say "✗ $base not found — it is the file Hermes injects; cannot build $target without it."; exit 1; }

  # Gitignore BEFORE writing: the override carries PII and this repo is public.
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    grep -qxF "$target" .gitignore 2>/dev/null \
      || printf '\n# personalized project prompt (contains owner profile) — local only\n%s\n' "$target" >> .gitignore
  fi

  # Regenerated from AGENTS.md every run: the override REPLACES AGENTS.md for this
  # directory, so a stale copy would silently pin an old soul. Never appended to.
  { cat "$base"; printf '\n%s\n\n## OWNER PROFILE\n\n' "$SENTINEL"; cat "$prof"; } > "$target"
  say "✓ $target written = $base + owner profile (local only, regenerated from $base)."
  say "  Hermes injects it in place of $base; $base stays tracked and unchanged."

  # Safety check: owner files must be ignored.
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    for f in "$prof" "$target"; do
      git check-ignore -q "$f" && say "  ✓ $f is gitignored" || say "  ⚠ $f is NOT ignored — do not push until fixed"
    done
  fi
}

set_name() {
  local newname="$1" force="${2:-}"
  local current

  # python3 does the JSON surgery: the Hermes installer brings no Node, and the economy
  # runtime already requires python3, so it is the one interpreter this repo can count on.
  command -v python3 >/dev/null 2>&1 || { say "✗ python3 is required to rewrite identity.json."; exit 1; }

  current="$(python3 -c "import json;print(json.load(open('identity.json'))['marketplace_name'])" 2>/dev/null || echo "")"

  if [ "$current" != "$PLACEHOLDER" ] && [ -n "$current" ] && [ "$force" != "--force" ]; then
    say "✓ Already personalized as \"$current\" (idempotent; pass --force to change)."
    return 0
  fi

  python3 - "$newname" <<'PY'
import json, sys
name = sys.argv[1]
with open("identity.json", encoding="utf-8") as fh:
    j = json.load(fh)
j["marketplace_name"] = name
j.pop("marketplace_name_note", None)
with open("identity.json", "w", encoding="utf-8") as fh:
    json.dump(j, fh, indent=2)
    fh.write("\n")
PY
  say "✓ identity.json marketplace_name → \"$newname\""

  # Reflect the name in the metadata template (name field only; leave <...> mint fields).
  python3 - "$newname" <<'PY' 2>/dev/null || true
import json, os, sys
p = "metadata/metadata.template.json"
if os.path.exists(p):
    with open(p, encoding="utf-8") as fh:
        j = json.load(fh)
    j["name"] = sys.argv[1]
    with open(p, "w", encoding="utf-8") as fh:
        json.dump(j, fh, indent=2)
        fh.write("\n")
PY

  [ -x scripts/make-manifest.sh ] && bash scripts/make-manifest.sh >/dev/null && say "✓ manifest regenerated"
  say "  Your agent answers to \"$newname\", \"iNFT\", and \"Hermes\"."
}

case "${1:-}" in
  ""|-h|--help) say "Usage: personalize.sh \"Agent Name\" [--force]  |  personalize.sh --apply-owner  (writes the gitignored AGENTS.override.md)"; exit 0 ;;
  --apply-owner) apply_owner ;;
  *) set_name "$1" "${2:-}" ;;
esac
