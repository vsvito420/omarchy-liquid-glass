#!/bin/bash
# Install or remove the Liquid Glass screensaver.
#
#   screensaver/install.sh           install / update
#   screensaver/install.sh --remove  uninstall, back to Omarchy's stock screensaver
#
# Nothing in /usr/share/omarchy is touched. The renderers go to ~/.local/bin, settings
# to ~/.config/liquid-glass/screensaver.toml (kept on update);
# a small ttfx shim goes to /usr/local/bin (ahead of /usr/bin on PATH), which is
# the only step that needs sudo and is skipped when the shim is already current.
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
BINS=(liquid-glass-screensaver liquid-glass-retro liquid-glass-sun)
CONF="$HOME/.config/liquid-glass/screensaver.toml"
SHIM=/usr/local/bin/ttfx
MARKER="Liquid Glass screensaver shim"

ours() { [[ -f $SHIM ]] && grep -q "$MARKER" "$SHIM"; }

if [[ ${1:-} == --remove ]]; then
  for b in "${BINS[@]}"; do rm -f "$BIN_DIR/$b"; done
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

for b in "${BINS[@]}"; do install -Dm755 "$DIR/$b" "$BIN_DIR/$b"; done
[[ -f $CONF ]] || install -Dm644 "$DIR/screensaver.toml" "$CONF"  # keep user settings
if ! cmp -s "$DIR/ttfx" "$SHIM"; then
  sudo install -m755 "$DIR/ttfx" "$SHIM"
fi

echo "Liquid Glass screensaver installed."
echo "It runs while a liquid-glass theme is applied; other themes keep the stock screensaver."
echo
echo "  Style / location: $CONF"
echo "  Preview:   omarchy launch screensaver force"
echo "  Timelapse: LG_SPEED=1 liquid-glass-screensaver"
echo "  Remove:    $0 --remove"
