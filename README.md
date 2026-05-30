<p align="center">
  <img src="https://avatars.githubusercontent.com/u/258253854?v=4" alt="stc - Save Token Cost (a fork of rtk)" width="500">
</p>

<p align="center">
  <strong>stc — High-performance CLI proxy that reduces LLM token consumption by 60-90%</strong>
</p>

<p align="center">
  <a href="https://github.com/harshitsinghbhandari/stc/actions"><img src="https://github.com/harshitsinghbhandari/stc/workflows/Security%20Check/badge.svg" alt="CI"></a>
  <a href="https://github.com/harshitsinghbhandari/stc/releases"><img src="https://img.shields.io/github/v/release/harshitsinghbhandari/stc" alt="Release"></a>
  <a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="License: Apache 2.0"></a>
</p>

<p align="center">
  <a href="https://github.com/harshitsinghbhandari/stc">Website</a> &bull;
  <a href="#installation">Install</a> &bull;
  <a href="docs/guide/resources/troubleshooting.md">Troubleshooting</a> &bull;
  <a href="docs/contributing/ARCHITECTURE.md">Architecture</a>
</p>

<p align="center">
  <a href="README.md">English</a> &bull;
  <a href="README_fr.md">Francais</a> &bull;
  <a href="README_zh.md">中文</a> &bull;
  <a href="README_ja.md">日本語</a> &bull;
  <a href="README_ko.md">한국어</a> &bull;
  <a href="README_es.md">Espanol</a>
</p>

---

> **Attribution / Fork notice**
> **stc** (Save Token Cost) is a modified fork of [**rtk** (Rust Token Killer)](https://github.com/rtk-ai/rtk),
> originally created by **Patrick Szymkowiak** and the rtk-ai/rtk contributors, licensed under
> Apache-2.0. This fork is maintained by **Harshit Singh Bhandari**, renames the user-facing
> command to `stc`, adds transparent Codex CLI auto-rewrite, and ships its own Homebrew release
> pipeline. See [NOTICE](NOTICE) for full attribution. The internal crate, data directory, and
> `RTK_*` environment variables retain the `stc` name for compatibility.

---

stc filters and compresses command outputs before they reach your LLM context. Single Rust binary, 100+ supported commands, <10ms overhead.

## Token Savings (30-min Claude Code Session)

| Operation | Frequency | Standard | stc | Savings |
|-----------|-----------|----------|-----|---------|
| `ls` / `tree` | 10x | 2,000 | 400 | -80% |
| `cat` / `read` | 20x | 40,000 | 12,000 | -70% |
| `grep` / `rg` | 8x | 16,000 | 3,200 | -80% |
| `git status` | 10x | 3,000 | 600 | -80% |
| `git diff` | 5x | 10,000 | 2,500 | -75% |
| `git log` | 5x | 2,500 | 500 | -80% |
| `git add/commit/push` | 8x | 1,600 | 120 | -92% |
| `cargo test` / `npm test` | 5x | 25,000 | 2,500 | -90% |
| `ruff check` | 3x | 3,000 | 600 | -80% |
| `pytest` | 4x | 8,000 | 800 | -90% |
| `go test` | 3x | 6,000 | 600 | -90% |
| `docker ps` | 3x | 900 | 180 | -80% |
| **Total** | | **~118,000** | **~23,900** | **-80%** |

> Estimates based on medium-sized TypeScript/Rust projects. Actual savings vary by project size.

## Installation

### Homebrew (recommended)

```bash
brew tap harshitsinghbhandari/homebrew-tap
brew install stc
```

### Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/refs/heads/master/install.sh | sh
```

> Installs to `~/.local/bin`. Add to PATH if needed:
> ```bash
> echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
> ```

### Cargo

```bash
cargo install --git https://github.com/harshitsinghbhandari/stc
```

### Pre-built Binaries

Download from [releases](https://github.com/harshitsinghbhandari/stc/releases):
- macOS: `stc-x86_64-apple-darwin.tar.gz` / `stc-aarch64-apple-darwin.tar.gz`
- Linux: `stc-x86_64-unknown-linux-musl.tar.gz` / `stc-aarch64-unknown-linux-gnu.tar.gz`
- Windows: `stc-x86_64-pc-windows-msvc.zip`

> **Windows users**: Extract the zip and place `stc.exe` somewhere in your PATH (e.g. `C:\Users\<you>\.local\bin`). Run stc from **Command Prompt**, **PowerShell**, or **Windows Terminal** — do not double-click the `.exe` (it will flash and close). For the best experience, use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) where the full hook system works natively. See [Windows setup](#windows) below for details.

### Verify Installation

```bash
stc --version   # Should show "stc 0.1.0"
stc gain        # Should show token savings stats
```

> **Note**: stc is published only via the Homebrew tap above, the install script, or `cargo install --git`. It is not on crates.io, so do not run `cargo install stc`.

## Quick Start

```bash
# 1. Install for your AI tool
stc init -g                     # Claude Code / Copilot (default)
stc init -g --gemini            # Gemini CLI
stc init -g --codex             # Codex (OpenAI)
stc init -g --agent cursor      # Cursor
stc init --agent windsurf       # Windsurf
stc init --agent cline          # Cline / Roo Code
stc init --agent kilocode       # Kilo Code
stc init --agent antigravity    # Google Antigravity
stc init --agent hermes         # Hermes

# 2. Restart your AI tool, then test
git status  # Automatically rewritten to stc git status
```

Hook-based agents rewrite Bash commands (e.g., `git status` -> `stc git status`) before execution. Plugin-based agents, including Hermes, use their plugin API to rewrite commands before execution. The agent receives compact output without needing to call `stc` explicitly.

**Important:** the hook only runs on Bash tool calls. Claude Code built-in tools like `Read`, `Grep`, and `Glob` do not pass through the Bash hook, so they are not auto-rewritten. To get stc's compact output for those workflows, use shell commands (`cat`/`head`/`tail`, `rg`/`grep`, `find`) or call `stc read`, `stc grep`, or `stc find` directly.

## How It Works

```
  Without stc:                                    With stc:

  Claude  --git status-->  shell  -->  git         Claude  --git status-->  stc  -->  git
    ^                                   |            ^                      |          |
    |        ~2,000 tokens (raw)        |            |   ~200 tokens        | filter   |
    +-----------------------------------+            +------- (filtered) ---+----------+
```

Four strategies applied per command type:

1. **Smart Filtering** - Removes noise (comments, whitespace, boilerplate)
2. **Grouping** - Aggregates similar items (files by directory, errors by type)
3. **Truncation** - Keeps relevant context, cuts redundancy
4. **Deduplication** - Collapses repeated log lines with counts

## Commands

### Files
```bash
stc ls .                        # Token-optimized directory tree
stc read file.rs                # Smart file reading
stc read file.rs -l aggressive  # Signatures only (strips bodies)
stc smart file.rs               # 2-line heuristic code summary
stc find "*.rs" .               # Compact find results
stc grep "pattern" .            # Grouped search results
stc diff file1 file2            # Condensed diff
```

### Git
```bash
stc git status                  # Compact status
stc git log -n 10               # One-line commits
stc git diff                    # Condensed diff
stc git add                     # -> "ok"
stc git commit -m "msg"         # -> "ok abc1234"
stc git push                    # -> "ok main"
stc git pull                    # -> "ok 3 files +10 -2"
```

### GitHub CLI
```bash
stc gh pr list                  # Compact PR listing
stc gh pr view 42               # PR details + checks
stc gh issue list               # Compact issue listing
stc gh run list                 # Workflow run status
```

### Test Runners
```bash
stc jest                        # Jest compact (failures only)
stc vitest                      # Vitest compact (failures only)
stc playwright test             # E2E results (failures only)
stc pytest                      # Python tests (-90%)
stc go test                     # Go tests (NDJSON, -90%)
stc cargo test                  # Cargo tests (-90%)
stc rake test                   # Ruby minitest (-90%)
stc rspec                       # RSpec tests (JSON, -60%+)
stc err <cmd>                   # Filter errors only from any command
stc test <cmd>                  # Generic test wrapper - failures only (-90%)
```

### Build & Lint
```bash
stc lint                        # ESLint grouped by rule/file
stc lint biome                  # Supports other linters
stc tsc                         # TypeScript errors grouped by file
stc next build                  # Next.js build compact
stc prettier --check .          # Files needing formatting
stc cargo build                 # Cargo build (-80%)
stc cargo clippy                # Cargo clippy (-80%)
stc ruff check                  # Python linting (JSON, -80%)
stc golangci-lint run           # Go linting (JSON, -85%)
stc rubocop                     # Ruby linting (JSON, -60%+)
```

### Package Managers
```bash
stc pnpm list                   # Compact dependency tree
stc pip list                    # Python packages (auto-detect uv)
stc pip outdated                # Outdated packages
stc bundle install              # Ruby gems (strip Using lines)
stc prisma generate             # Schema generation (no ASCII art)
```

### AWS
```bash
stc aws sts get-caller-identity # One-line identity
stc aws ec2 describe-instances  # Compact instance list
stc aws lambda list-functions   # Name/runtime/memory (strips secrets)
stc aws logs get-log-events     # Timestamped messages only
stc aws cloudformation describe-stack-events  # Failures first
stc aws dynamodb scan           # Unwraps type annotations
stc aws iam list-roles          # Strips policy documents
stc aws s3 ls                   # Truncated with tee recovery
```

### Containers
```bash
stc docker ps                   # Compact container list
stc docker images               # Compact image list
stc docker logs <container>     # Deduplicated logs
stc docker compose ps           # Compose services
stc kubectl pods                # Compact pod list
stc kubectl logs <pod>          # Deduplicated logs
stc kubectl services            # Compact service list
```

### Data & Analytics
```bash
stc json config.json            # Structure without values
stc deps                        # Dependencies summary
stc env -f AWS                  # Filtered env vars
stc log app.log                 # Deduplicated logs
stc curl <url>                  # Truncate + save full output
stc wget <url>                  # Download, strip progress bars
stc summary <long command>      # Heuristic summary
stc proxy <command>             # Raw passthrough + tracking
```

### Token Savings Analytics
```bash
stc gain                        # Summary stats
stc gain --graph                # ASCII graph (last 30 days)
stc gain --history              # Recent command history
stc gain --daily                # Day-by-day breakdown
stc gain --all --format json    # JSON export for dashboards

stc discover                    # Find missed savings opportunities
stc discover --all --since 7    # All projects, last 7 days

stc session                     # Show RTK adoption across recent sessions
```

## Global Flags

```bash
-u, --ultra-compact    # ASCII icons, inline format (extra token savings)
-v, --verbose          # Increase verbosity (-v, -vv, -vvv)
```

## Examples

**Directory listing:**
```
# ls -la (45 lines, ~800 tokens)        # stc ls (12 lines, ~150 tokens)
drwxr-xr-x  15 user staff 480 ...       my-project/
-rw-r--r--   1 user staff 1234 ...       +-- src/ (8 files)
...                                      |   +-- main.rs
                                         +-- Cargo.toml
```

**Git operations:**
```
# git push (15 lines, ~200 tokens)       # stc git push (1 line, ~10 tokens)
Enumerating objects: 5, done.             ok main
Counting objects: 100% (5/5), done.
Delta compression using up to 8 threads
...
```

**Test output:**
```
# cargo test (200+ lines on failure)     # stc test cargo test (~20 lines)
running 15 tests                          FAILED: 2/15 tests
test utils::test_parse ... ok               test_edge_case: assertion failed
test utils::test_format ... ok              test_overflow: panic at utils.rs:18
...
```

## Auto-Rewrite Hook

The most effective way to use stc. The hook transparently intercepts Bash commands and rewrites them to stc equivalents before execution.

**Result**: 100% stc adoption across all conversations and subagents, zero token overhead.

**Scope note:** this only applies to Bash tool calls. Claude Code built-in tools such as `Read`, `Grep`, and `Glob` bypass the hook, so use shell commands or explicit `stc` commands when you want RTK filtering there.

### Setup

```bash
stc init -g                 # Install hook + RTK.md (recommended)
stc init -g --opencode      # OpenCode plugin (instead of Claude Code)
stc init -g --auto-patch    # Non-interactive (CI/CD)
stc init -g --hook-only     # Hook only, no RTK.md
stc init --show             # Verify installation
```

After install, **restart Claude Code**.

## Windows

stc works on Windows with some limitations. The auto-rewrite hook (`rtk-rewrite.sh`) requires a Unix shell, so on native Windows RTK falls back to **CLAUDE.md injection mode** — your AI assistant receives RTK instructions but commands are not rewritten automatically.

### Recommended: WSL (full support)

For the best experience, use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Windows Subsystem for Linux). Inside WSL, RTK works exactly like Linux — full hook support, auto-rewrite, everything:

```bash
# Inside WSL
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/refs/heads/master/install.sh | sh
stc init -g
```

### Native Windows (limited support)

On native Windows (cmd.exe / PowerShell), RTK filters work but the hook does not auto-rewrite commands:

```powershell
# 1. Download and extract stc-x86_64-pc-windows-msvc.zip from releases
# 2. Add stc.exe to your PATH
# 3. Initialize (falls back to CLAUDE.md injection)
stc init -g
# 4. Use stc explicitly
stc cargo test
stc git status
```

**Important**: Do not double-click `stc.exe` — it is a CLI tool that prints usage and exits immediately. Always run it from a terminal (Command Prompt, PowerShell, or Windows Terminal).

| Feature | WSL | Native Windows |
|---------|-----|----------------|
| Filters (cargo, git, etc.) | Full | Full |
| Auto-rewrite hook | Yes | No (CLAUDE.md fallback) |
| `stc init -g` | Hook mode | CLAUDE.md mode |
| `stc gain` / analytics | Full | Full |

## Supported AI Tools

RTK supports 13 AI coding tools. Each integration rewrites shell commands to `stc` equivalents for 60-90% token savings where the agent supports command interception.

| Tool | Install | Method |
|------|---------|--------|
| **Claude Code** | `stc init -g` | PreToolUse hook (bash) |
| **GitHub Copilot (VS Code)** | `stc init -g --copilot` | PreToolUse hook — transparent rewrite |
| **GitHub Copilot CLI** | `stc init -g --copilot` | PreToolUse deny-with-suggestion (CLI limitation) |
| **Cursor** | `stc init -g --agent cursor` | preToolUse hook (hooks.json) |
| **Gemini CLI** | `stc init -g --gemini` | BeforeTool hook |
| **Codex** | `stc init -g --codex` | AGENTS.md + RTK.md instructions |
| **Windsurf** | `stc init --agent windsurf` | .windsurfrules (project-scoped) |
| **Cline / Roo Code** | `stc init --agent cline` | .clinerules (project-scoped) |
| **OpenCode** | `stc init -g --opencode` | Plugin TS (tool.execute.before) |
| **OpenClaw** | `openclaw plugins install ./openclaw` | Plugin TS (before_tool_call) |
| **Hermes** | `stc init --agent hermes` | Python plugin adapter (terminal command mutation via `stc rewrite`) |
| **Mistral Vibe** | Planned ([#800](https://github.com/harshitsinghbhandari/stc/issues/800)) | Blocked on upstream |
| **Kilo Code** | `stc init --agent kilocode` | .kilocode/rules/rtk-rules.md (project-scoped) |
| **Google Antigravity** | `stc init --agent antigravity` | .agents/rules/antigravity-rtk-rules.md (project-scoped) |

For per-agent setup details, override controls, and graceful degradation, see the [Supported Agents guide](https://github.com/harshitsinghbhandari/stc/guide/getting-started/supported-agents). The Hermes plugin source and tests live in `hooks/hermes/`; installed Hermes runtime files still live under `~/.hermes/plugins/rtk-rewrite/`.

## Configuration

`~/.config/rtk/config.toml` (macOS: `~/Library/Application Support/rtk/config.toml`):

```toml
[hooks]
exclude_commands = ["curl", "playwright"]  # skip rewrite for these

[tee]
enabled = true          # save raw output on failure (default: true)
mode = "failures"       # "failures", "always", or "never"
```

When a command fails, RTK saves the full unfiltered output so the LLM can read it without re-executing:

```
FAILED: 2/15 tests
[full output: ~/.local/share/rtk/tee/1707753600_cargo_test.log]
```

For the full config reference (all sections, env vars, per-project filters), see the [Configuration guide](https://github.com/harshitsinghbhandari/stc/guide/getting-started/configuration).

### Uninstall

```bash
stc init -g --uninstall     # Remove hook, RTK.md, settings.json entry
cargo uninstall stc          # Remove binary
brew uninstall stc           # If installed via Homebrew
```

## Documentation

- **[github.com/harshitsinghbhandari/stc/guide](https://github.com/harshitsinghbhandari/stc/guide)** — full user guide (installation, supported agents, what gets optimized, analytics, configuration, troubleshooting)
- **[INSTALL.md](INSTALL.md)** — detailed installation reference
- **[ARCHITECTURE.md](docs/contributing/ARCHITECTURE.md)** — system design and technical decisions
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — contribution guide
- **[SECURITY.md](SECURITY.md)** — security policy

## Privacy & Telemetry

RTK can collect **anonymous, aggregate usage metrics** once per day. Telemetry is **disabled by default** and requires **explicit opt-in consent** (GDPR Art. 6, 7) during `stc init` or via `stc telemetry enable`. This data helps us build a better product: identifying which commands need filters, which filters need improvement, and how much value RTK delivers. For the full list of fields, data handling, and contributor guidelines, see **[docs/TELEMETRY.md](docs/TELEMETRY.md)**.

**What is collected and why:**

| Category | Data | Why |
|----------|------|-----|
| Identity | Salted device hash (SHA-256, not reversible) | Count unique installations without tracking individuals |
| Environment | RTK version, OS, architecture, install method | Know which platforms to support and test |
| Usage volume | Command count (24h), total commands, tokens saved (24h/30d/total) | Measure adoption and value delivered |
| Quality | Top 5 passthrough commands (0% savings), parse failure count, commands with <30% savings | Identify missing filters and weak ones to improve |
| Ecosystem | Command category distribution (e.g. git 45%, cargo 20%, js 15%) | Prioritize filter development for popular ecosystems |
| Retention | Days since first use, active days in last 30 | Understand engagement and detect churn |
| Adoption | AI agent hook type (claude/gemini/codex), custom TOML filter count | Track integration coverage and DSL adoption |
| Configuration | Whether config.toml exists, number of excluded commands, project count | Understand user maturity and customization patterns |
| Features | Usage counts for meta-commands (gain, discover, proxy, verify) | Know which RTK features are valued vs unused |
| Economics | Estimated USD savings (based on API token pricing) | Quantify the value RTK provides to users |

All data is **aggregate counts or anonymized command names** (first 3 words, no arguments). Top commands report only tool names (e.g. "git", "cargo"), never full command lines.

**What is NOT collected:** source code, file paths, command arguments, secrets, environment variables, personal data, or repository contents.

**Manage telemetry:**
```bash
stc telemetry status     # Check current consent state
stc telemetry enable     # Give consent (interactive prompt)
stc telemetry disable    # Withdraw consent — stops all collection immediately
stc telemetry forget     # Withdraw consent + delete all local data + request server-side erasure
```

**Override via environment:**
```bash
export RTK_TELEMETRY_DISABLED=1   # Blocks telemetry regardless of consent
```

## Star History

<a href="https://www.star-history.com/?repos=harshitsinghbhandari%2Fstc&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=harshitsinghbhandari/stc&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=harshitsinghbhandari/stc&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=harshitsinghbhandari/stc&type=date&legend=top-left" />
 </picture>
</a>

## StarMapper

<a href="https://starmapper.bruniaux.com/harshitsinghbhandari/stc">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://starmapper.bruniaux.com/api/map-image/harshitsinghbhandari/stc?theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://starmapper.bruniaux.com/api/map-image/harshitsinghbhandari/stc?theme=light" />
    <img alt="StarMapper" src="https://starmapper.bruniaux.com/api/map-image/harshitsinghbhandari/stc" />
  </picture>
</a>

## Core team

- **Patrick Szymkowiak** — Founder
  [GitHub](https://github.com/pszymkowiak) · [LinkedIn](https://www.linkedin.com/in/patrick-szymkowiak/)
- **Florian Bruniaux** — Core contributor
  [GitHub](https://github.com/FlorianBruniaux) · [LinkedIn](https://www.linkedin.com/in/florian-bruniaux-43408b83/)
- **Adrien Eppling** — Core contributor
  [GitHub](https://github.com/aeppling) · [LinkedIn](https://www.linkedin.com/in/adrien-eppling/)

## Contributing

Contributions welcome! Please open an issue or PR on [GitHub](https://github.com/harshitsinghbhandari/stc).

Join the community on [Discord](https://discord.gg/RySmvNF5kF).

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.

## Disclaimer

See [DISCLAIMER.md](DISCLAIMER.md).
