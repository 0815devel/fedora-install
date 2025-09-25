#!/usr/bin/env bash
#/usr/local/bin/backup-home.bash

set -euo pipefail

# ------------------------
# Konfiguration
# ------------------------
REPO="/tank/backup/home-borg-repo"
HOST=$(hostname)
NOW=$(date +%Y-%m-%d-%H%M)

# Dateien/Ordner, die nicht gesichert werden sollen
EXCLUDES=(
    "$HOME/.cache"
    "$HOME/Downloads"
)

# Exclude-Parameter für Borg
EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(--exclude "$e")
done

# ------------------------
# Backup erstellen
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
