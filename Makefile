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

tf-init:
	terraform -chdir=tf init
.PHONY: tf-init

tf-validate:
	terraform -chdir=tf validate
.PHONY: tf-validate

update-blarg:
	@curl --proto '=https' --tlsv1.3 \
		--silent \
		--show-error \
		--fail \
		--location "https://github.com/pcrockett/blarg/raw/refs/heads/main/blarg" \
		> bin/blarg.tmp
	@chmod +x bin/blarg.tmp
	@mv bin/blarg.tmp bin/blarg
.PHONY: update-blarg
