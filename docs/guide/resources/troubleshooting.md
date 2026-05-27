---
title: Troubleshooting
description: Common RTK issues and how to fix them
sidebar:
  order: 2
---

# Troubleshooting

## `stc gain` says "not a stc command"

**Symptom:**
```bash
$ stc gain
rtk: 'gain' is not a stc command. See 'rtk --help'.
```

**Cause:** You installed **Rust Type Kit** (`reachingforthejack/rtk`) instead of **Rust Token Killer** (`harshitsinghbhandari/stc`). They share the same binary name.

**Fix:**
```bash
cargo uninstall rtk
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/master/install.sh | sh
stc gain    # should now show token savings stats
```

## How to tell which stc you have

| If `stc gain`... | You have |
|------------------|----------|
| Shows token savings dashboard | Rust Token Killer ✅ |
| Returns "not a stc command" | Rust Type Kit ❌ |

## AI assistant not using RTK

**Symptom:** Claude Code (or another agent) runs `cargo test` instead of `stc cargo test`.

**Checklist:**

1. Verify RTK is installed:
   ```bash
   stc --version
   stc gain
   ```

2. Initialize the hook:
   ```bash
   stc init --global    # Claude Code
   stc init --global --cursor    # Cursor
   stc init --global --opencode  # OpenCode
   ```

3. Restart your AI assistant.

4. Verify hook status:
   ```bash
   stc init --show
   ```

5. Check `settings.json` has the hook registered (Claude Code):
   ```bash
   cat ~/.claude/settings.json | grep rtk
   ```

## RTK not found after `cargo install`

**Symptom:**
```bash
$ stc --version
zsh: command not found: rtk
```

**Cause:** `~/.cargo/bin` is not in your PATH.

**Fix:**

For bash (`~/.bashrc`) or zsh (`~/.zshrc`):
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

For fish (`~/.config/fish/config.fish`):
```fish
set -gx PATH $HOME/.cargo/bin $PATH
```

Then reload:
```bash
source ~/.zshrc    # or ~/.bashrc
stc --version
```

## RTK on Windows

### Double-clicking rtk.exe does nothing

**Symptom:** You double-click `rtk.exe`, a terminal flashes and closes instantly.

**Cause:** RTK is a command-line tool. With no arguments, it prints usage and exits. The console window opens and closes before you can read anything.

**Fix:** Open a terminal first, then run RTK from there:
- Press `Win+R`, type `cmd`, press Enter
- Or open PowerShell or Windows Terminal
- Then run: `stc --version`

### Hook not working (no auto-rewrite)

**Symptom:** `stc init -g` shows "Falling back to --claude-md mode" on Windows.

**Cause:** The auto-rewrite hook (`rtk-rewrite.sh`) requires a Unix shell. Native Windows doesn't have one.

**Fix:** Use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) for full hook support:
```bash
# Inside WSL
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/refs/heads/master/install.sh | sh
stc init -g    # full hook mode works in WSL
```

On native Windows, RTK falls back to CLAUDE.md injection. Your AI assistant gets RTK instructions but won't auto-rewrite commands. It can still use RTK manually: `stc cargo test`, `stc git status`, etc.

### Node.js tools not found

**Symptom:**
```
stc vitest --run
Error: program not found
```

**Cause:** On Windows, Node.js tools are installed as `.CMD`/`.BAT` wrappers. Older RTK versions couldn't find them.

**Fix:** Update to RTK v0.23.1+:
```bash
cargo install --git https://github.com/harshitsinghbhandari/stc
stc --version    # should be 0.23.1+
```

## Compilation error during installation

```bash
rustup update stable
rustup default stable
cargo clean
cargo build --release
cargo install --path . --force
```

Minimum required Rust version: 1.70+.

## OpenCode not using RTK

```bash
stc init --global --opencode
# restart OpenCode
stc init --show    # should show "OpenCode: plugin installed"
```

## `cargo install rtk` installs the wrong package

If Rust Type Kit is published to crates.io under the name `stc`, `cargo install rtk` may install the wrong one.

Always use the explicit URL:

```bash
cargo install --git https://github.com/harshitsinghbhandari/stc
```

## Run the diagnostic script

From the RTK repository root:

```bash
bash scripts/check-installation.sh
```

Checks:
- RTK installed and in PATH
- Correct version (Token Killer, not Type Kit)
- Available features
- Claude Code integration
- Hook status

## Still stuck?

Open an issue: https://github.com/harshitsinghbhandari/stc/issues
