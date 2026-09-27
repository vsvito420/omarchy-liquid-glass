#!/usr/bin/env python3
"""Native messaging host: reports the active Omarchy theme and its background color."""
import json
import re
import struct
import sys
from pathlib import Path

CURRENT = Path.home() / ".local/state/omarchy/current"


def read(path):
    try:
        return path.read_text().strip()
    except OSError:
        return None


header = sys.stdin.buffer.read(4)
if len(header) == 4:
    sys.stdin.buffer.read(struct.unpack("=I", header)[0])

background = None
colors = read(CURRENT / "theme" / "colors.toml")
if colors:
    m = re.search(r'^\s*background\s*=\s*"(#[0-9a-fA-F]{6})"', colors, re.M)
    if m:
        background = m.group(1)

reply = json.dumps({"theme": read(CURRENT / "theme.name"), "background": background}).encode()
sys.stdout.buffer.write(struct.pack("=I", len(reply)) + reply)
sys.stdout.buffer.flush()
