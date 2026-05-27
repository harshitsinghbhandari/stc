# RTK - Rust Token Killer (Google Antigravity)

**Usage**: Token-optimized CLI proxy for shell commands.

## Rule

Always prefix shell commands with `stc` to minimize token consumption.

Examples:

```bash
stc git status
stc cargo test
stc ls src/
stc grep "pattern" src/
stc find "*.rs" .
stc docker ps
stc gh pr list
```

## Meta Commands

```bash
stc gain              # Show token savings
stc gain --history    # Command history with savings
stc discover          # Find missed RTK opportunities
stc proxy <cmd>       # Run raw (no filtering, for debugging)
```

## Why

RTK filters and compresses command output before it reaches the LLM context, saving 60-90% tokens on common operations. Always use `stc <cmd>` instead of raw commands.
