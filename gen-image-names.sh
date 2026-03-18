#!/bin/bash
# usage: ./gen-image-names.sh <path-to-docker-compose-yaml>

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <path-to-docker-compose-yaml>" >&2
  exit 1
fi

compose_file=$1

if [ ! -f "$compose_file" ]; then
  echo "Error: file not found: $compose_file" >&2
  exit 1
fi

# jq-compatible filter for yq: iterate service objects and read image if present
yq -r '.services[]?.image? // empty' "$compose_file" | while IFS= read -r image; do
  echo "--image $image"
done
