#!/bin/bash
set -eu

echo "Exporting secrets..."

# IFS=',' read -ra SECRETS <<< "$1"
for secret in "${SECRETS[@]}"; do
    export "$secret"="$(gcloud secrets versions access latest --secret="$secret")"
    # echo "$secret: ${!secret}"    # for debugging purposes
done
