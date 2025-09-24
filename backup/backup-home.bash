#!/usr/bin/env bash
set -euo pipefail

REPO="/tank/backups/home-borg-repo"
HOST=$(hostname)
NOW=$(date +%Y-%m-%d-%H%M)

borg create \
    --verbose \
    --filter AME \
    --list \
    --stats \
    --progress \
    --compression lz4 \
    "$REPO::$HOST-$NOW" \
    "$HOME"
