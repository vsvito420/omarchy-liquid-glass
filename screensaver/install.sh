#!/bin/bash
# Install or remove the Liquid Glass screensaver.
#
#   screensaver/install.sh           install / update
#   screensaver/install.sh --remove  uninstall, back to Omarchy's stock screensaver
#
# Nothing in /usr/share/omarchy is touched. The renderer goes to ~/.local/bin;
# a small ttfx shim goes to /usr/local/bin (ahead of /usr/bin on PATH), which is
# the only step that needs sudo and is skipped when the shim is already current.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin/liquid-glass-screensaver"
SHIM=/usr/local/bin/ttfx
MARKER="Liquid Glass screensaver shim"

ours() { [[ -f $SHIM ]] && grep -q "$MARKER" "$SHIM"; }

if [[ ${1:-} == --remove ]]; then
  rm -f "$BIN"
  if ours; then sudo rm -f "$SHIM"; fi
  echo "Removed. Omarchy's stock screensaver is back."
  exit 0
fi

if [[ ! -x /usr/bin/ttfx ]]; then
  echo "ttfx not found in /usr/bin — is this an Omarchy system?" >&2
  exit 1
fi
if ! python3 -c 'import sys; sys.exit(sys.version_info < (3, 11))' 2>/dev/null; then
  echo "Needs Python 3.11 or newer." >&2
  exit 1
fi
if [[ -e $SHIM ]] && ! ours; then
  echo "$SHIM exists and isn't ours — not overwriting it." >&2
  exit 1
fi

install -Dm755 "$DIR/liquid-glass-screensaver" "$BIN"
if ! cmp -s "$DIR/ttfx" "$SHIM"; then
  sudo install -m755 "$DIR/ttfx" "$SHIM"
fi

echo "Liquid Glass screensaver installed."
echo "It runs while a liquid-glass theme is applied; other themes keep the stock screensaver."
echo
echo "  Preview:   omarchy launch screensaver force"
echo "  Timelapse: LG_SPEED=1 liquid-glass-screensaver"
echo "  Remove:    $0 --remove"
