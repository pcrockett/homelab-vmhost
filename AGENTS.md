# Homelab VM Host

## Setup
`just lint` runs all linting (pre-commit + custom rules).
`./bin/blarg --verbose targets/main.bash` to apply all targets.
`make` to reapply changed targets.

## Architecture
- **blarg** (in `bin/blarg`) is the target-based Bash config management tool. Entry point: `targets/main.bash`.
- Targets are in `targets/` directory, organized by category (core, kernel, network, boot, backup, misc, cli, vm).
- External targets from `pcrockett/blarg-targets@v0.4.2` (see `blarg.conf`).
- Templates for new targets in `templates/`.

## Environment
- This repo is designed to run from a "control" machine, applying blarg config to the vmhost machine over SSH (`just apply`, using `SSH_DEST`).
- The agent does NOT have access to the vmhost machine, so don't bother trying to connect to it.
- It is possible that agents are running inside the "scratch" VM that this repo provisions (see `targets/vm/scratch/`). In that case, the VM's own state can be inspected directly, but host-side tooling like `incus` is unavailable.

## Linting
- Custom lint rules in `bin/lint.sh`: no raw `sudo` (use `as_root` instead), no core/main dependencies.
- Pre-commit: shellcheck, shfmt, yamllint, yamlfmt, actionlint, tagref.
- Tools managed via mise (see `mise.toml`).

## Commands
- `just lint`: full lint check
- `just ssh`: interactive shell via tailscale-ssh
- `just remote clear-logs`: delete old screen log files
- `just update-blarg`: update blarg from upstream
- `./bin/newtarget NAME [TEMPLATE]`: create new target with template

## Conventions
- Target naming: `[a-z0-9\-/]+` (enforced by `newtarget`)
- Prefer GNU-style long command flags when you know for a fact they exist (e.g. `--create-home` instead of `-m`). Don't tie yourself in knots attaining the long form; short flags are fine too.
- EditorConfig: 2-space indent for most files, 4-space for Python/Rust/Justfile, tabs for Makefile/Caddyfile.
- SSH destination set via `SSH_DEST` env var (see `.envrc.template`).

## Policies
- This repo is public. Never hardcode IPs or IP ranges; detect them at runtime instead.
- Comments should only contain details a developer is likely to ask about in the future. Don't restate what's obvious from the code.
- Never call `sudo` or `as_root` inside `satisfied_if`. It runs on every apply, including dry-runs, so it must stay a cheap, read-only, non-interactive check.
