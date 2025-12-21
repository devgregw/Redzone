#!/bin/zsh

set -euo pipefail

p12_base64=""
p12_password=""
p12_name=""

# Parse arguments
# -b <base64-encoded-p12-file> -p <p12-password> -n <p12-file-name>
while getopts "b:p:n:" opt; do
    case $opt in
        b) p12_base64="$OPTARG" ;;
        p) p12_password="$OPTARG" ;;
        n) p12_name="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

cert_path=$RUNNER_TEMP/$p12_name.p12
keychain_path=$RUNNER_TEMP/signing.keychain-db

echo 'Decoding certificate...'
echo -n "$p12_base64" | base64 -D -i - -o "$cert_path"

# Create keychain if it doesn't exist
if [ ! -f "$keychain_path" ]; then
    echo 'Creating keychain...'
    security create-keychain -p "$p12_password" "$keychain_path"
    security set-keychain-settings -lut 21600 "$keychain_path"
    security unlock-keychain -p "$p12_password" "$keychain_path"
fi

# Import certificate into keychain
echo 'Importing certificate into keychain...'
security import "$cert_path" -P "$p12_password" -A -t cert -f pkcs12 -k "$keychain_path"
security list-keychain -d user -s "$keychain_path"
security find-identity -v -p codesigning
