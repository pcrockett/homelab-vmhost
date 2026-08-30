# Homelab VM Host

## Setup
`just lint` runs all linting (pre-commit + custom rules).
`./bin/blarg --verbose targets/main.bash` to apply all targets.
`make` to reapply changed targets.

**Note**: AI agents cannot apply changes to the machine directly. After file changes are made, users must run the blarg command manually to apply them.

## Architecture
- **blarg** (in `bin/blarg`) is the target-based Bash config management tool. Entry point: `targets/main.bash`.
- Targets are in `targets/` directory, organized by category (core, kernel, network, boot, backup, misc, cli, vm).
- External targets from `pcrockett/blarg-targets@v0.4.2` (see `blarg.conf`).
- Templates for new targets in `templates/`.
- **Firewall**: Managed by firewalld with default DROP policy. Zones: drop (default), trusted (lo), home (wlp2s0), libvirt (virbr0), incus (incusbr0), tailscale (tailscale0).
- **Global variables**: Defined in `lib.d/10_vars.sh` (e.g., `REPO_CONFIG_DIR`, `STATE_DIR`, `LIBVIRT_IMAGES_DIR`).

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
- File permissions: Prefer `u=...,g=...,o=...` syntax for `install --mode` (e.g., `u=rw,g=r,o=r` over `644`).
