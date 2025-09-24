#!/usr/bin/env bash
set -euo pipefail

REPO="/tank/backups/home-borg-repo"
SNAPSHOT="$1"  # z.B. "hostname-2025-09-24-1530"

borg extract "$REPO::$SNAPSHOT"
