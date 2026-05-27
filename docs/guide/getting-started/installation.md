---
title: Installation
description: Install RTK via curl, Homebrew, Cargo, or from source, and verify the correct version
sidebar:
  order: 1
---

# Installation

## Name collision warning

Two unrelated projects share the name `stc`. Make sure you install the right one:

- **Rust Token Killer** (`harshitsinghbhandari/stc`) — this project, a token-saving CLI proxy
- **Rust Type Kit** (`reachingforthejack/rtk`) — a different tool for generating Rust types

The easiest way to verify you have the correct one: run `stc gain`. It should display token savings stats. If it returns "command not found", you either have the wrong package or RTK is not installed.

## Check before installing

```bash
stc --version   # should print: stc x.y.z
stc gain        # should show token savings stats
```

If both commands work, RTK is already installed. Skip to [Project initialization](#project-initialization).

## Quick install (Linux and macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/master/install.sh | sh
```

## Homebrew (macOS and Linux)

```bash
brew install harshitsinghbhandari/homebrew-tap/rtk
```

## Cargo

:::caution[Name collision risk]
`cargo install rtk` may install **Rust Type Kit** instead of Rust Token Killer — two unrelated projects share the same crate name. Use the explicit Git URL to guarantee the correct package:
:::

```bash
cargo install --git https://github.com/harshitsinghbhandari/stc rtk
```

## Pre-built binaries (Windows, Linux, macOS)

Download from [GitHub releases](https://github.com/harshitsinghbhandari/stc/releases):

- macOS: `rtk-x86_64-apple-darwin.tar.gz` / `rtk-aarch64-apple-darwin.tar.gz`
- Linux: `rtk-x86_64-unknown-linux-musl.tar.gz` / `rtk-aarch64-unknown-linux-gnu.tar.gz`
- Windows: `rtk-x86_64-pc-windows-msvc.zip`

**Windows users**: Extract the zip and place `rtk.exe` in a directory on your PATH. Run RTK from Command Prompt, PowerShell, or Windows Terminal — do not double-click the `.exe` (it prints usage and exits immediately). For full hook support, use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) instead.

## Verify installation

```bash
stc --version   # stc x.y.z
stc gain        # token savings dashboard
```

If `stc gain` fails but `stc --version` succeeds, you installed Rust Type Kit by mistake. Uninstall it first:

```bash
cargo uninstall rtk
```

Then reinstall using one of the methods above.

## Project initialization

Run once per project to enable the Claude Code hook:

```bash
stc init
```

For a global install that patches `settings.json` automatically:

```bash
stc init --global
```

## Uninstall

```bash
stc init -g --uninstall    # remove hook, RTK.md, and settings.json entry
cargo uninstall stc         # remove binary (if installed via Cargo)
brew uninstall stc          # remove binary (if installed via Homebrew)
```
