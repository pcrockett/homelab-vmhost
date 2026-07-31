[private]
_default:
    @just --list

# Run lint script, including pre-commit
lint:
    ./bin/lint.sh

# Update remote config
remote:
    @# ssh flags:
    @#
    @# -t: allocate tty for interactivity
    @#
    @# screen flags:
    @#
    @# -U: run in unicode mode
    @# -L: turn on output logging (saves output on server to ~/screenlog.0)
    @#
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    @# -c (command): command to execute
    tailscale ssh "${SSH_DEST}" -t -- screen -U -L bash -l -i -c config_update

# Open interactive shell via SSH
ssh:
    @# ssh flags:
    @#
    @# -t: allocate tty for interactivity
    @#
    @# screen flags:
    @#
    @# -U: run in unicode mode
    @# -L: turn on output logging (saves output on server to ~/screenlog.0)
    @#
    @# bash flags:
    @#
    @# -i (interactive): uses .bashrc
    @# -l (login): emulates a regular login shell
    @# -c (command): command to execute
    tailscale ssh "${SSH_DEST}" -t -- screen -U -L bash -l -i

# Run btop on server
btop:
    tailscale ssh "${SSH_DEST}" -t -- btop --utf-force

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
