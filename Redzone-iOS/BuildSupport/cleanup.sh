#!/bin/zsh

rm -rf ~/Library/MobileDevice/Provisioning\ Profiles || true
rm -rf ${{ github.workspace }}/private_keys || true
rm -rf $RUNNER_TEMP/* || true
