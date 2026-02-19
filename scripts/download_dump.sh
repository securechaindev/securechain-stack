#!/usr/bin/env bash
# Donwload the latest dump from zenodo
curl -L -C - -O \
     --retry 999 \
     --retry-delay 5 \
     --retry-all-errors \
     "https://zenodo.org/records/17692376/files/SecureChainData.tar.zst?download=1"

# Extract only the seeds folder to project root
tar -I zstd -xvf SecureChainData.tar.zst seeds/
