# scratch vm

disposable vm. to tear it down and recreate it:

```bash
just remote scratch_destroy && just apply
```

## minimal provisioning

after the scratch vm is created, some targets here automatically provision it with a
few basics:

- creates a user account matching the username on the vm host
- gives the user passwordless sudo
- connects the machine to the tailnet via the auth key under the `machine.scratch`
  bitwarden entry
- blocks access to the physical wifi network (and all IPv6) via an incus network
  ACL, except tailscale's direct peer connections (UDP 41641)
