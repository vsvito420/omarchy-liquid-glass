#!/bin/bash
# Snapshot the generated theme files of the *currently applied* liquid-glass
# variant into the theme dir, with glass transparency baked in.
set -e
v=$1; A=$2; BAR=$3; CARD=$4; RIM=$5
C=~/.local/state/omarchy/current/theme; T=~/.config/omarchy/themes/liquid-glass-$v
# Terminals: translucent background, opaque text
sed "/^\[colors/a alpha=$A" $C/foot.ini > $T/foot.ini
{ cat $C/alacritty.toml; printf '\n[window]\nopacity = %s\nblur = true\n' $A; } > $T/alacritty.toml
{ cat $C/kitty.conf; printf '\nbackground_opacity %s\ndynamic_background_opacity yes\n' $A; } > $T/kitty.conf
{ cat $C/ghostty.conf; printf '\nbackground-opacity = %s\nbackground-blur = true\n' $A; } > $T/ghostty.conf
# Shell: translucent surfaces, light rim borders, faint scrims (below ignore_alpha so only cards blur)
python3 - "$C/shell.toml" "$T/shell.toml" "$BAR" "$CARD" "$RIM" <<'PY'
import re,sys
src,dst,bar,card,rim=sys.argv[1:]
out=[];sec=None
for line in open(src):
    m=re.match(r'^\[([^\]]+)\]',line)
    if m: sec=m.group(1)
    k=line.split('=')[0].strip()
    def setv(val): return re.sub(r'=\s*.*', '= '+val, line, count=1)
    if k=='background-alpha':
        line=setv(bar if sec=='bar' else card)+('\n' if not line.endswith('\n') else '')
    elif k=='scrim-alpha': line=setv('0.12')+'\n'
    elif k in('border','selected-border') and sec!='bar':
        line=setv('"'+rim+'"')+'\n'
    elif k=='border-alpha' and sec in('popups','notifications','menu','launcher','tooltip','polkit','lock'):
        line=setv('0.45')+'\n'
    out.append(line)
open(dst,'w').write(''.join(out))
PY
