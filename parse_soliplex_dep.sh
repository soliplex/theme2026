#!/usr/bin/env bash
# Parse soliplex_frontend dependency info from pubspec.yaml
# Outputs a URL suitable for: git clone <url> or git checkout

PUBSPEC_FILE="${1:-pubspec.yaml}"

if [[ ! -f "$PUBSPEC_FILE" ]]; then
    echo "Error: $PUBSPEC_FILE not found" >&2
    exit 1
fi

URL=$(awk '/soliplex_frontend:/,/^[^ ]/ { if (/url:/) print $2 }' "$PUBSPEC_FILE")
REF=$(awk '/soliplex_frontend:/,/^[^ ]/ { if (/ref:/) print $2 }' "$PUBSPEC_FILE")

echo "$URL"
echo "$REF"
