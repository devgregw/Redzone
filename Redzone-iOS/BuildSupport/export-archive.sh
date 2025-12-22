#!/bin/zsh

set -euo pipefail

export_options=""
issuer_id=""
key_id=""

# Parse arguments
# -e <export options> -i <auth key issuer ID> -k <auth key ID>
while getopts "e:i:k:" opt; do
    case $opt in
        i) issuer_id="$OPTARG" ;;
        e) export_options="$OPTARG" ;;
        k) key_id="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

xcodebuild \
    -exportArchive \
    -archivePath "$RUNNER_TEMP/Redzone.xcarchive" \
    -exportOptionsPlist "$export_options" \
    -exportPath "$RUNNER_TEMP/Redzone.ipa" \
    -authenticationKeyIssuerID "$issuer_id" \
    -authenticationKeyID "$key_id" \
    -authenticationKeyPath "$RUNNER_TEMP/private_keys/AuthKey_$key_id.p8" \
    2>&1 | xcbeautify --renderer github-actions
