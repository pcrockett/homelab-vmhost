run:
	./bin/blarg --verbose targets/main.bash
.PHONY: run

remote:
	@# bash flags:
	@#
	@# -i (interactive): uses .bashrc
	@# -l (login): emulates a regular login shell
	@# -c (command): command to execute
	tailscale ssh "$(SSH_DEST)" -- bash -l -i -c config_update
.PHONY: remote
