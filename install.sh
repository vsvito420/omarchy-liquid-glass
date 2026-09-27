#!/bin/bash
# Install Liquid Glass (dark + light) into ~/.config/omarchy/themes.
# Copied (not cloned) so Omarchy treats them as user themes and keeps
# hyprland.lua and the terminal configs that carry the glass effect.
set -e
SRC="$(cd "$(dirname "$0")" && pwd)/themes"
DEST="$HOME/.config/omarchy/themes"
mkdir -p "$DEST"
for t in liquid-glass-dark liquid-glass-light; do
  rm -rf "${DEST:?}/$t"
  cp -r "$SRC/$t" "$DEST/$t"
  echo "Installed $t"
done
echo
echo "Apply with:"
echo "  omarchy theme set \"Liquid Glass Dark\""
echo "  omarchy theme set \"Liquid Glass Light\""
