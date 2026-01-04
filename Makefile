run:
	./bin/blarg --verbose targets/main.bash
.PHONY: run

remote:
	@# ssh flags:
	@#
	@# -t: allocate tty for interactivity
	@#
	@# bash flags:
	@#
	@# -i (interactive): uses .bashrc
	@# -l (login): emulates a regular login shell
	@# -c (command): command to execute
	tailscale ssh "$(SSH_DEST)" -t -- bash -l -i -c config_update
.PHONY: remote
