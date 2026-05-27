# RTK Installation Guide - For AI Coding Assistants

## ⚠️ Name Collision Warning

**There are TWO completely different projects named "rtk":**

1. ✅ **Rust Token Killer** (this project) - LLM token optimizer
   - Repos: `harshitsinghbhandari/stc`
   - Has `rtk gain` command for token savings stats

2. ❌ **Rust Type Kit** (reachingforthejack/rtk) - DIFFERENT PROJECT
   - Rust codebase query tool and type generator
   - **DO NOT install if you want token optimization**

## Pre-Installation Check (REQUIRED)

**AI assistants should ALWAYS verify if RTK is already installed before attempting installation.**

```bash
# Check if RTK is installed
stc --version

# CRITICAL: Verify it's the Token Killer (not Type Kit)
stc gain    # Should show token savings stats, NOT "command not found"

# Check installation path
which stc
```

If `rtk gain` works, you have the **correct** RTK installed. **DO NOT reinstall**. Skip to "Project Initialization".

If `rtk gain` fails but `rtk --version` succeeds, you have the **wrong** RTK (Type Kit). Uninstall and reinstall the correct one (see below).

## Installation (only if RTK not available or wrong RTK installed)

### Step 0: Uninstall Wrong RTK (if needed)

If you accidentally installed Rust Type Kit:

```bash
cargo uninstall rtk
```

### Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/master/install.sh | sh
```

After installation, **verify you have the correct rtk**:
```bash
stc gain  # Must show token savings stats (not "command not found")
```

### Alternative: Manual Installation

```bash
# From the stc fork repository (installs the `stc` binary)
cargo install --git https://github.com/harshitsinghbhandari/stc

# ALWAYS VERIFY after installation
stc gain  # MUST show token savings, not "command not found"
```

> **Note**: stc is not published to crates.io. Install via the Homebrew tap
> (`brew tap harshitsinghbhandari/homebrew-tap && brew install stc`), the
> install script, or `cargo install --git` above.

## Project Initialization

### Which mode to choose?

```
  Do you want RTK active across ALL Claude Code projects?
  │
  ├─ YES → stc init -g              (recommended)
  │         Hook + RTK.md (~10 tokens in context)
  │         Commands auto-rewritten transparently
  │
  ├─ YES, minimal → stc init -g --hook-only
  │         Hook only, nothing added to CLAUDE.md
  │         Zero tokens in context
  │
  └─ NO, single project → stc init
            Local CLAUDE.md only (137 lines)
            No hook, no global effect
```

### Recommended: Global Hook-First Setup

**Best for: All projects, automatic RTK usage**

```bash
stc init -g
# → Installs hook to ~/.claude/hooks/rtk-rewrite.sh
# → Creates ~/.claude/RTK.md (10 lines, meta commands only)
# → Adds @RTK.md reference to ~/.claude/CLAUDE.md
# → Prompts: "Patch settings.json? [y/N]"
# → If yes: patches + creates backup (~/.claude/settings.json.bak)

# Automated alternatives:
stc init -g --auto-patch    # Patch without prompting
stc init -g --no-patch      # Print manual instructions instead

# Verify installation
stc init --show  # Check hook is installed and executable
```

**Token savings**: ~99.5% reduction (2000 tokens → 10 tokens in context)

**What is settings.json?**
Claude Code's hook registry. RTK adds a PreToolUse hook that rewrites commands transparently. Without this, Claude won't invoke the hook automatically.

```
  Claude Code          settings.json        rtk-rewrite.sh        RTK binary
       │                    │                     │                    │
       │  "git status"      │                     │                    │
       │ ──────────────────►│                     │                    │
       │                    │  PreToolUse trigger  │                    │
       │                    │ ───────────────────►│                    │
       │                    │                     │  rewrite command   │
       │                    │                     │  → stc git status  │
       │                    │◄────────────────────│                    │
       │                    │  updated command     │                    │
       │                    │                                          │
       │  execute: stc git status                                      │
       │ ─────────────────────────────────────────────────────────────►│
       │                                                               │  filter
       │  "3 modified, 1 untracked ✓"                                  │
       │◄──────────────────────────────────────────────────────────────│
```

**Backup Safety**:
RTK backs up existing settings.json before changes. Restore if needed:
```bash
cp ~/.claude/settings.json.bak ~/.claude/settings.json
```

### Alternative: Local Project Setup

**Best for: Single project without hook**

```bash
cd /path/to/your/project
stc init  # Creates ./CLAUDE.md with full RTK instructions (137 lines)
```

**Token savings**: Instructions loaded only for this project

### Upgrading from Previous Version

#### From old 137-line CLAUDE.md injection (pre-0.22)

```bash
stc init -g  # Automatically migrates to hook-first mode
# → Removes old 137-line block
# → Installs hook + RTK.md
# → Adds @RTK.md reference
```

#### From old hook with inline logic (pre-0.24) — ⚠️ Breaking Change

RTK 0.24.0 replaced the inline command-detection hook (~200 lines) with a **thin delegator** that calls `rtk rewrite`. The binary now contains the rewrite logic, so adding new commands no longer requires a hook update.

The old hook still works but won't benefit from new rules added in future releases.

```bash
# Upgrade hook to thin delegator
stc init --global

# Verify the new hook is active
stc init --show
# Should show: ✅ Hook: ... (thin delegator, up to date)
```

## Common User Flows

### First-Time User (Recommended)
```bash
# 1. Install RTK
cargo install --git https://github.com/harshitsinghbhandari/stc
stc gain  # Verify (must show token stats)

# 2. Setup with prompts
stc init -g
# → Answer 'y' when prompted to patch settings.json
# → Creates backup automatically

# 3. Restart Claude Code
# 4. Test: git status (should use rtk)
```

### CI/CD or Automation
```bash
# Non-interactive setup (no prompts)
stc init -g --auto-patch

# Verify in scripts
stc init --show | grep "Hook:"
```

### Conservative User (Manual Control)
```bash
# Get manual instructions without patching
stc init -g --no-patch

# Review printed JSON snippet
# Manually edit ~/.claude/settings.json
# Restart Claude Code
```

### Temporary Trial
```bash
# Install hook
stc init -g --auto-patch

# Later: remove everything
stc init -g --uninstall

# Restore backup if needed
cp ~/.claude/settings.json.bak ~/.claude/settings.json
```

## Installation Verification

```bash
# Basic test
stc ls .

# Test with git
stc git status

# Test with pnpm
stc pnpm list

# Test with Vitest
stc vitest
```

## Uninstalling

### Complete Removal (Global Installations Only)

```bash
# Complete removal (global installations only)
stc init -g --uninstall

# What gets removed:
#   - Hook: ~/.claude/hooks/rtk-rewrite.sh
#   - Context: ~/.claude/RTK.md
#   - Reference: @RTK.md line from ~/.claude/CLAUDE.md
#   - Registration: RTK hook entry from settings.json

# Restart Claude Code after uninstall
```

**For Local Projects**: Manually remove RTK block from `./CLAUDE.md`

### Binary Removal

```bash
# If installed via cargo
cargo uninstall rtk

# If installed via package manager
brew uninstall stc          # macOS Homebrew
sudo apt remove stc         # Debian/Ubuntu
sudo dnf remove stc         # Fedora/RHEL
```

### Restore from Backup (if needed)

```bash
cp ~/.claude/settings.json.bak ~/.claude/settings.json
```

## Essential Commands

### Files
```bash
stc ls .              # Compact tree view
stc read file.rs      # Optimized reading
stc grep "pattern" .  # Grouped search results
```

### Git
```bash
stc git status        # Compact status
stc git log -n 10     # Condensed logs
stc git diff          # Optimized diff
stc git add .         # → "ok ✓"
stc git commit -m "msg"  # → "ok ✓ abc1234"
stc git push          # → "ok ✓ main"
```

### Pnpm (fork only)
```bash
stc pnpm list     # Dependency tree (-70% tokens)
stc pnpm outdated # Available updates (-80-90%)
stc pnpm install  # Silent installation
```

### Tests
```bash
stc cargo test      # Filtered Cargo test output (-90%)
stc go test         # Filtered Go tests (NDJSON, -90%)
stc jest            # Filtered Jest output (-99.6%)
stc vitest          # Filtered Vitest output (-99.6%)
stc playwright test # Filtered Playwright output (-94%)
stc pytest          # Filtered Python tests (-90%)
stc rake test       # Filtered Ruby tests (-90%)
stc rspec           # Filtered RSpec tests (-60%)
stc test <cmd>      # Generic test wrapper - failures only (-90%)
```

### Statistics
```bash
stc gain              # Token savings
stc gain --graph      # With ASCII graph
stc gain --history    # With command history
```

## Validated Token Savings

### Production T3 Stack Project
| Operation | Standard | RTK | Reduction |
|-----------|----------|-----|-----------|
| `vitest` | 102,199 chars | 377 chars | **-99.6%** |
| `git status` | 529 chars | 217 chars | **-59%** |
| `pnpm list` | ~8,000 tokens | ~2,400 | **-70%** |
| `pnpm outdated` | ~12,000 tokens | ~1,200-2,400 | **-80-90%** |

### Typical Claude Code Session (30 min)
- **Without RTK**: ~150,000 tokens
- **With RTK**: ~45,000 tokens
- **Savings**: **70% reduction**

## Troubleshooting

### RTK command not found after installation
```bash
# Check PATH
echo $PATH | grep -o '[^:]*\.cargo[^:]*'

# Add to PATH if needed (~/.bashrc or ~/.zshrc)
export PATH="$HOME/.cargo/bin:$PATH"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### RTK command not available (e.g., vitest)
```bash
# Check branch
cd /path/to/rtk
git branch

# Switch to feat/vitest-support if needed
git checkout feat/vitest-support

# Reinstall
cargo install --path . --force
```

### Compilation error
```bash
# Update Rust
rustup update stable

# Clean and recompile
cargo clean
cargo build --release
cargo install --path . --force
```

## Support and Contributing

- **Website**: https://github.com/harshitsinghbhandari/stc
- **Contact**: https://github.com/harshitsinghbhandari/stc/issues
- **Troubleshooting**: See [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for common issues
- **GitHub issues**: https://github.com/harshitsinghbhandari/stc/issues
- **Pull Requests**: https://github.com/harshitsinghbhandari/stc/pulls

⚠️ **If you installed the wrong stc (Type Kit)**, see [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md#problem-rtk-gain-command-not-found)

## AI Assistant Checklist

Before each session:

- [ ] Verify RTK is installed: `rtk --version`
- [ ] If not installed → follow "Install from fork"
- [ ] If project not initialized → `rtk init`
- [ ] Use `stc` for ALL git/pnpm/test/vitest commands
- [ ] Check savings: `rtk gain`

**Golden Rule**: AI coding assistants should ALWAYS use `stc` as a proxy for shell commands that generate verbose output (git, pnpm, npm, cargo test, vitest, docker, kubectl).
