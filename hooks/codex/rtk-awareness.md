# stc - Save Token Cost (Codex CLI)

**Usage**: Token-optimized CLI proxy for shell commands. A fork of rtk (Rust Token Killer).

## Rule

Always prefix shell commands with `stc`.

Examples:

```bash
stc git status
stc cargo test
stc npm run build
stc pytest -q
```

## Meta Commands

```bash
stc gain            # Token savings analytics
stc gain --history  # Recent command savings history
stc proxy <cmd>     # Run raw command without filtering
```

## Verification

```bash
stc --version
stc gain
which stc
```
