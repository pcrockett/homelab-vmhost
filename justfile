[private]
_default:
    @just --list

# Run lint script, including pre-commit
lint:
    ./bin/lint.sh

# Update remote config
remote command="config_update":
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    @# -c (command): command to execute
    ./bin/screen-ssh.sh bash -l -i -c "{{command}}"

# Open interactive shell via SSH
ssh:
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    ./bin/screen-ssh.sh bash -l -i

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
