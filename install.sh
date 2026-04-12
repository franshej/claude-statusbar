#!/bin/sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
DEST="$CLAUDE_DIR/statusline-command.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

# Copy the script
cp "$SCRIPT_DIR/statusline-command.sh" "$DEST"
chmod +x "$DEST"
echo "Installed statusline-command.sh to $DEST"

# Update settings.json
python3 - "$DEST" "$SETTINGS" <<'PYEOF'
import sys, json, os

dest = sys.argv[1]
settings_path = sys.argv[2]

if os.path.exists(settings_path):
    with open(settings_path) as f:
        settings = json.load(f)
else:
    settings = {}

settings['statusLine'] = {
    'type': 'command',
    'command': f"sh {dest}"
}

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)

print(f"Updated {settings_path}")
PYEOF

echo "Done. Restart Claude Code to see the statusbar."
