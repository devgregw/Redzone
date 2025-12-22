#!/bin/zsh

set -euo pipefail

# Periphery will read the config YAML file and merge it with these CLI args
periphery \
    scan \
    --skip-build \
    --relative-results \
    --format github-actions \
    --index-store-path "$RUNNER_TEMP/DerivedData"
