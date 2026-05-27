# Releasing stc

`stc` ships its own release pipeline. Releases are cut on
`harshitsinghbhandari/stc` and the Homebrew formula is published to the
separate tap repo `harshitsinghbhandari/homebrew-tap`.

End users install with:

```bash
brew tap harshitsinghbhandari/homebrew-tap
brew install stc
```

---

## One-time setup (manual — do this before the first release)

These steps cannot be automated by CI and must be performed once by the
repository owner.

### 1. Create the Homebrew tap repository

Create a new **public** GitHub repository named exactly:

```
harshitsinghbhandari/homebrew-tap
```

The repo only needs to exist (it can be empty). The release pipeline creates
and updates `Formula/stc.rb` inside it automatically. Homebrew requires the
`homebrew-` prefix; `brew tap harshitsinghbhandari/homebrew-tap` maps to this
repo.

### 2. Create the tap push token (`HOMEBREW_TAP_TOKEN`)

The release workflow in **this** repo pushes the generated formula to the tap
repo. Cross-repository writes are not possible with the default `GITHUB_TOKEN`,
so a Personal Access Token is required.

1. Create a token:
   - **Fine-grained PAT** (recommended): GitHub → Settings → Developer settings
     → Fine-grained tokens → Generate new token.
     - Resource owner: `harshitsinghbhandari`
     - Repository access: **Only select repositories** → `harshitsinghbhandari/homebrew-tap`
     - Permissions: **Repository permissions → Contents → Read and write**
   - **Classic PAT** (alternative): scope `repo` (full control of private repos)
     is sufficient.
2. Add it as a secret on **this** repo (`harshitsinghbhandari/stc`):
   - Settings → Secrets and variables → Actions → **New repository secret**
   - Name: `HOMEBREW_TAP_TOKEN`
   - Value: the PAT from step 1

> No other secrets are required. Releases on this repo use the built-in
> `GITHUB_TOKEN`. The upstream `APP_CLIENT_ID`, `APP_PRIVATE_KEY`,
> `RTK_TELEMETRY_*`, and `RTK_DISCORD_RELEASE` secrets are **not** used by this
> fork and do not need to be configured.

---

## Cutting a release

### Option A — push a version tag (recommended)

1. Make sure `version` in `Cargo.toml` is the version you want to release
   (e.g. `0.40.0`) and that `develop`/`master` is in the state you want.
2. Create and push an annotated tag matching `vMAJOR.MINOR.PATCH`:

   ```bash
   git tag -a v0.40.0 -m "stc v0.40.0"
   git push origin v0.40.0
   ```

3. The `Release` workflow (`.github/workflows/release.yml`) then:
   - builds binaries for macOS (x86_64/arm64), Linux (x86_64-musl/arm64-gnu),
     and Windows (x86_64), plus `.deb` and `.rpm` packages;
   - creates the GitHub Release on `harshitsinghbhandari/stc` with all assets
     and `checksums.txt` (using the built-in `GITHUB_TOKEN`);
   - generates `Formula/stc.rb` with the real version + SHA-256 checksums and
     pushes it to `harshitsinghbhandari/homebrew-tap` using
     `HOMEBREW_TAP_TOKEN`.

### Option B — manual dispatch

GitHub → Actions → **Release** → **Run workflow**, and provide the `tag`
(e.g. `v0.40.0`). Check `prerelease` to skip the Homebrew formula update.

> Note: when a tag is created by automation using the default `GITHUB_TOKEN`,
> GitHub will not re-trigger the tag-push event. The `CD` workflow therefore
> invokes `release.yml` directly via `workflow_call`. For manual releases, use
> Option A (push the tag yourself) or Option B.

---

## Verifying a release

```bash
# After the formula is published to the tap:
brew tap harshitsinghbhandari/homebrew-tap
brew install stc
stc --version      # -> stc 0.40.0
stc gain
```

Or via the install script / cargo:

```bash
curl -fsSL https://raw.githubusercontent.com/harshitsinghbhandari/stc/refs/heads/master/install.sh | sh
# or
cargo install --git https://github.com/harshitsinghbhandari/stc
```

---

## What changed from the upstream pipeline

This fork replaced the upstream (`rtk-ai/rtk`) release setup:

- Releases are cut on `harshitsinghbhandari/stc` with `GITHUB_TOKEN` instead of
  a GitHub App token.
- The Homebrew formula is `stc` (class `Stc`) published to
  `harshitsinghbhandari/homebrew-tap` instead of `rtk` / `rtk-ai/homebrew-tap`.
- Release assets are named `stc-<target>.(tar.gz|zip)` and the binary is `stc`.
- The Discord release notification and telemetry build steps were removed.
