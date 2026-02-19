#!/usr/bin/env bash
set -e

PROFILE=${PROFILE:-stable}

if [[ "$PROFILE" != "stable" && "$PROFILE" != "latest" ]]; then
    echo "Error: PROFILE must be 'stable' or 'latest'"
    exit 1
fi

ENV_TEMPLATE="profiles/.env.${PROFILE}.template"

ENV_FILE=".env"

if [[ ! -f "$ENV_FILE" ]]; then
    cp "$ENV_TEMPLATE" "$ENV_FILE"
    echo "File $ENV_FILE generated from $ENV_TEMPLATE"
else
    echo "$ENV_FILE already exists, skipping"
fi
