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
- EditorConfig: 2-space indent for most files, 4-space for Python/Rust/Justfile, tabs for Makefile/Caddyfile.
- SSH destination set via `SSH_DEST` env var (see `.envrc.template`).
