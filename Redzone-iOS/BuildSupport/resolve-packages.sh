#!/bin/zsh

set -euo pipefail

xcodebuild \
    -resolvePackageDependencies \
    -disableAutomaticPackageResolution \
    -clonedSourcePackagesDirPath "$RUNNER_TEMP/clonedSourcePackages" 2>&1 | xcbeautify --renderer github-actions
