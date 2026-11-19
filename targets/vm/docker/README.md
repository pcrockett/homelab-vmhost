# docker vm

## minimal provisioning

after the docker vm is created, some targets here automatically provision it with a few
basics:

- creates a user account matching the username on the vm host
- gives the user passwordless sudo
- connects the machine to the tailnet via the auth key under the `machine.docker`
  bitwarden entry
