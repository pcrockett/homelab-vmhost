# Homelab VM host config

This is my configuration for my homelab VM host. It's running on an old HP Spectre x360
laptop with a dead battery.

## Getting started

Work in progress. I copy / pasted a lot of this from my
[tinkering laptop config](https://github.com/pcrockett/lappy), and I'm still getting it
up and running.

## How this works

I'm using my own target-based Bash configuration management tool
[blarg](https://github.com/pcrockett/blarg) to automate everything.
All targets are in the `targets` directory, with the entrypoint being
[`targets/main.bash`](./targets/main.bash). The `blarg` tool itself is
[included in this repository](./bin/blarg) so there's no need to install anything
beforehand.

Targets are organized in a dependency tree, making sure the right steps are taken in
the right order, and they are never re-run unless absolutely necessary. This means you
can execute all these targets however often you want, and only the necessary ones will
actually be applied.
