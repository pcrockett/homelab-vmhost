[private]
_default:
    @just --list

# Run lint script, including pre-commit
lint:
    ./bin/lint.sh

# Apply config to remote machine
apply *args:
    ./bin/blarg --ssh "${SSH_DEST}" --verbose {{args}} ./targets/main.bash

# Execute remote command (see config/bash/bashrc)
remote command: clear-logs
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    @# -c (command): command to execute
    ./bin/screen-ssh.sh bash -l -i -c "{{command}}"

# Open interactive shell via SSH
ssh:
    @# screen flags:
    @#
    @# -R: attach to a session if possible, otherwise create a new one
    @#
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    ./bin/tailscale-ssh.sh bash -l -i

# Run btop on server
btop:
    ./bin/tailscale-ssh.sh btop --utf-force

# Update blarg from upstream
update-blarg:
    @curl --proto '=https' --tlsv1.3 \
        --silent \
        --show-error \
        --fail \
        --location "https://github.com/pcrockett/blarg/raw/refs/heads/main/blarg" \
        >bin/blarg.tmp
    @chmod +x bin/blarg.tmp
    @mv bin/blarg.tmp bin/blarg

# Delete old screen log files
clear-logs:
    ./bin/tailscale-ssh.sh bash -l -i -c clear_logs
