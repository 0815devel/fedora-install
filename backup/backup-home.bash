#!/usr/bin/env bash
#/usr/local/bin/backup-home.bash

set -euo pipefail

# ------------------------
# Configuration
# ------------------------
REPO="/tank/backup/home-borg-repo"
HOST=$(hostname)
NOW=$(date +%Y-%m-%d-%H%M)

EXCLUDES=(
    "$HOME/.cache"
    "$HOME/Downloads"
)

EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(--exclude "$e")
done

# ------------------------
# Create Backup
# ------------------------
borg create \
    --verbose \
    --filter AME \
    --list \
    --stats \
    --progress \
    --compression lz4 \
    "${REPO}::${HOST}-${NOW}" \
    "$HOME" \
    "${EXCLUDE_ARGS[@]}"
