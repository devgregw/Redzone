#!/bin/zsh

set -euo pipefail

mobileprovision_tgz_base64=""

# Parse arguments
# -b <base64-encoded-mobileprovision-tgz-file>
while getopts "b:" opt; do
    case $opt in
        b) mobileprovision_tgz_base64="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))


mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo 'Decoding and extracting archive...'
tar -xf =( echo -n "$mobileprovision_tgz_base64" | base64 -D -i - -o - ) -C ~/Library/MobileDevice/Provisioning\ Profiles
ls -l ~/Library/MobileDevice/Provisioning\ Profiles
