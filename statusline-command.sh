#!/bin/sh
input=$(cat)
printf '%s' "$input" > /tmp/statusline-input.json

cwd=$(python3 -c "
import json
with open('/tmp/statusline-input.json') as f:
    d = json.load(f)
print(d.get('workspace', {}).get('current_dir') or d.get('cwd', '.'))
")

branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

python3 - "$branch" <<'PYEOF'
import sys, json, time

branch = sys.argv[1] if len(sys.argv) > 1 else ''

with open('/tmp/statusline-input.json') as f:
    data = json.load(f)

cwd = data.get('workspace', {}).get('current_dir') or data.get('cwd', '.')

model = data.get('model', {}).get('display_name', '')
ctx_pct = data.get('context_window', {}).get('used_percentage', 0)

five_hour = data.get('rate_limits', {}).get('five_hour', {})
rl_pct = five_hour.get('used_percentage', 0)
resets_at = five_hour.get('resets_at', 0)

secs_left = max(0, resets_at - int(time.time()))
h = secs_left // 3600
m = (secs_left % 3600) // 60
reset_str = f"{h}h {m}m" if h > 0 else f"{m}m"

CYAN    = '\033[0;36m'
YELLOW  = '\033[0;33m'
GREEN   = '\033[0;32m'
MAGENTA = '\033[0;35m'
GRAY    = '\033[0;90m'
RESET   = '\033[0m'

SEP     = f" {GRAY}|{RESET} "

parts = [f"{CYAN}{cwd}{RESET}"]
if branch:
    parts.append(f"{YELLOW}{branch}{RESET}")
if model:
    parts.append(f"{GRAY}{model}{RESET}")
parts.append(f"{GREEN}ctx {ctx_pct}%{RESET}")
parts.append(f"{MAGENTA}{int(rl_pct)}% (resets in {reset_str}){RESET}")


print(SEP.join(parts), end='')
PYEOF
