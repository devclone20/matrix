#!/bin/bash
# MATRIX — sync this checkout with GitHub (devclone20/matrix).
# Run: ./sync.sh
# Or from crontab, with the absolute path of your own checkout:
#   */30 * * * * /path/to/matrix/sync.sh
cd "$(dirname "$0")"
git fetch origin && git pull --ff-only origin main && echo "✓ MATRIX synced $(date)"
