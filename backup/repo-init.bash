#!/usr/bin/env bash
set -euo pipefail

#/usr/local/bin/repo-init.bash

# ------------------------
# Variablen
# ------------------------
REPO="/tank/backups/home-borg-repo"

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
