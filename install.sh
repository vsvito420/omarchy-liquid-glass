#!/bin/bash
# Install Liquid Glass (dark + light) into ~/.config/omarchy/themes.
# Copied (not cloned) so Omarchy treats them as user themes and keeps
# hyprland.lua and the terminal configs that carry the glass effect.
set -e
ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC="$ROOT/themes"
DEST="$HOME/.config/omarchy/themes"
mkdir -p "$DEST"
for t in liquid-glass-dark liquid-glass-light; do
  rm -rf "${DEST:?}/$t"
  cp -r "$SRC/$t" "$DEST/$t"
  echo "Installed $t"
done

# Optional retro screensaver, active only while a liquid-glass theme is applied.
echo
read -rp "Install the Liquid Glass screensaver? (hooks /usr/local/bin/ttfx, needs sudo) [y/N] " answer
if [[ $answer == [yY]* ]]; then
  install -Dm755 "$ROOT/screensaver/liquid-glass-screensaver" "$HOME/.local/bin/liquid-glass-screensaver"
  sudo install -m755 "$ROOT/screensaver/ttfx" /usr/local/bin/ttfx
  echo "Installed screensaver (preview: omarchy launch screensaver force)"
fi

echo
echo "Apply with:"
echo "  omarchy theme set \"Liquid Glass Dark\""
echo "  omarchy theme set \"Liquid Glass Light\""
