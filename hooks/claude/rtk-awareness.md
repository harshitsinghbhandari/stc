# stc - Save Token Cost

**Usage**: Token-optimized CLI proxy (60-90% savings on dev operations). A fork of rtk (Rust Token Killer).

## Meta Commands (always use stc directly)

```bash
stc gain              # Show token savings analytics
stc gain --history    # Show command usage history with savings
stc discover          # Analyze Claude Code history for missed opportunities
stc proxy <cmd>       # Execute raw command without filtering (for debugging)
```

## Installation Verification

```bash
stc --version         # Should show: stc X.Y.Z
stc gain              # Should work (not "command not found")
which stc             # Verify correct binary
```

## Hook-Based Usage

All other commands are automatically rewritten by the Claude Code hook.
Example: `git status` → `stc git status` (transparent, 0 tokens overhead)

Refer to CLAUDE.md for full command reference.
