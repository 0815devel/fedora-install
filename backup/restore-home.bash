#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <snapshot-name>"
    exit 1
fi

REPO="/tank/backups/home-borg-repo"
SNAPSHOT="$1"

borg extract "$REPO::$SNAPSHOT"
