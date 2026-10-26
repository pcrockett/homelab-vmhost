# scratch vm

disposable vm. to tear it down and recreate it:

```bash
just remote scratch_destroy && just apply
```

## minimal provisioning

after the scratch vm is created, some targets here automatically provision it with a
few basics:

- gets its own incus network (`scratchbr0`, IPv6 disabled) instead of the shared
  `incusbr0` bridge
- creates a user account matching the username on the vm host
- gives the user passwordless sudo
- connects the machine to the tailnet via the auth key under the `machine.scratch`
  bitwarden entry
- every VM network carries a default-deny ACL (`network-isolation`, applied by
  `targets/vm/network-isolated`): VMs may reach the internet and tailscale
  (UDP 41641), nothing else — not the host, the LAN, other VMs, or IPv6
