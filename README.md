# claude-statusbar

A statusbar for [Claude Code](https://claude.ai/code) that shows:

- **Full path** of the current working directory
- **Git branch** (when inside a git repo)
- **Context window usage** — how full the current context is
- **Rate limit usage** — your 5-hour Pro usage % and time until reset

![statusbar preview](https://i.imgur.com/placeholder.png)

## Requirements

- Claude Code
- Python 3 (pre-installed on macOS/most Linux distros)
- Git

## Install

```sh
git clone https://github.com/franshej/claude-statusbar.git
cd claude-statusbar
sh install.sh
```

Restart Claude Code — the statusbar will appear immediately.

## What it looks like

```
/Users/you/project | main | ctx 14% | 7% (resets in 4h 32m)
```

## Uninstall

Remove the `statusLine` block from `~/.claude/settings.json` and delete `~/.claude/statusline-command.sh`.
