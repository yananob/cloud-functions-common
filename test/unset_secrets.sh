#!/bin/bash
set -eu

echo "Unsetting secrets..."

# Remove credentials
# IFS=',' read -ra SECRETS <<< "$1"
for secret in "${SECRETS[@]}"; do
    unset "$secret"
done
