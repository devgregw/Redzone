#!/bin/zsh

set -euo pipefail

build_action=""
destination=""

# Parse arguments
# -a <action> -d <destination>
while getopts "a:d:" opt; do
    case $opt in
        a) build_action="$OPTARG" ;;
        d) destination="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

xcodebuild \
    $build_action \
    -scheme "Redzone" \
    -workspace "Redzone.xcworkspace" \
    -destination "$destination" \
    -derivedDataPath "$RUNNER_TEMP/DerivedData" \
    -disableAutomaticPackageResolution \
    -clonedSourcePackagesDirPath "$RUNNER_TEMP/clonedSourcePackages" 2>&1 | xcbeautify --renderer github-actions
