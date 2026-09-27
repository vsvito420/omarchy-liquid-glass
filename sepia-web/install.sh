#!/bin/bash
# Registers the native messaging host for Chromium and Google Chrome.
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
HOST_NAME=com.omarchy.sepia_web
EXT_ID=dnohjceejbadgggemehocihgnmdpgded

chmod +x "$DIR/host/sepia-host.py"

for browser in chromium google-chrome; do
  [[ -d $HOME/.config/$browser ]] || continue
  dest="$HOME/.config/$browser/NativeMessagingHosts"
  mkdir -p "$dest"
  cat >"$dest/$HOST_NAME.json" <<EOF
{
  "name": "$HOST_NAME",
  "description": "Reports the active Omarchy theme to the Omarchy Sepia Web extension",
  "path": "$DIR/host/sepia-host.py",
  "type": "stdio",
  "allowed_origins": ["chrome-extension://$EXT_ID/"]
}
EOF
  echo "Registered native host for $browser"
done

echo
echo "Now load the extension: chrome://extensions → Developer mode → Load unpacked →"
echo "  $DIR/extension"
