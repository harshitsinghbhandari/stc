# Codex CLI Hooks

> Part of [`hooks/`](../README.md) — see also [`src/hooks/`](../../src/hooks/README.md) for installation code

## Specifics

- **Transparent rewrite via a programmatic `PreToolUse` hook.** `rtk init --codex`
  registers `rtk hook codex` in Codex's `hooks.json` with `matcher = "Bash"`.
  Codex pipes the tool call as JSON on stdin; the native handler in
  `src/hooks/hook_cmd.rs` (`run_codex`) rewrites the `tool_input.command` via the
  shared registry (`discover/registry`) and returns it in `hookSpecificOutput.updatedInput`.
- Rewrite logic is **not** reimplemented here — `run_codex` delegates to the same
  `rewrite_command` used by every other agent integration.
- Codex 0.133.0 only applies `updatedInput` when paired with
  `permissionDecision: "allow"` (it parses `"ask"` but does not implement it, and
  rejects `updatedInput` without an allow). So a rewrite is always emitted as an
  explicit allow — mirroring the Cursor hook. Unsupported commands, RTK deny-rule
  matches, heredocs, and parse errors pass through unchanged (the hook never blocks).
- `rtk-awareness.md` is still injected into `AGENTS.md` with an `@RTK.md` reference
  as a complementary prompt-level fallback.
- Installed to `$CODEX_HOME` when set, otherwise `~/.codex/`, by `rtk init --codex`
  (project mode writes `.codex/hooks.json`). `hooks.json` is merged idempotently and
  the entry is removed cleanly by `rtk init -g --codex --uninstall`.
