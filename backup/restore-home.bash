#!/usr/bin/env bash
set -euo pipefail

#/usr/local/bin/restore-home.bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <snapshot-name>"
    exit 1
fi

REPO="/tank/backup/home-borg-repo"
SNAPSHOT="$1"

borg extract "$REPO::$SNAPSHOT"
