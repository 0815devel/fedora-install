#!/usr/bin/env bash
#/usr/local/bin/repo-init.bash

set -euo pipefail

# ------------------------
# Variables
# ------------------------
REPO="/tank/backup/home-borg-repo"

# ------------------------
# Init Repository
# ------------------------
if [ ! -d "$REPO" ]; then
    echo "Init of Borg-Repository $REPO..."
    borg init --encryption=none "$REPO"
    echo "Init of Repository done."
else
    echo "Repository already existing: $REPO"
fi
