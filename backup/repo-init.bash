#!/usr/bin/env bash
#/usr/local/bin/repo-init.bash

set -euo pipefail

# ------------------------
# Variablen
# ------------------------
REPO="/tank/backup/home-borg-repo"

# ------------------------
# Repository initialisieren
# ------------------------
if [ ! -d "$REPO" ]; then
    echo "Initialisiere Borg-Repository unter $REPO..."
    borg init --encryption=none "$REPO"
    echo "Repository erfolgreich initialisiert."
else
    echo "Repository existiert bereits: $REPO"
fi
