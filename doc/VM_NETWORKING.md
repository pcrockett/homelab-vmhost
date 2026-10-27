# VM Networking Strategy

<!-- [tag:vm/networking-strategy] -->

Default network configuration for VMs:

- One Incus network per VM, unless there's an explicit need for VMs to communicate
- Networks are created in `[ref:vm/networks-created]` and ACLs are configured in
  `[ref:vm/networks-isolated]` to drop all outgoing traffic for all private network
  ranges
- The ACLs do allow one exception: VMs may send and receive Tailscale traffic to private
  network ranges. This is a big performance boost that enables my other devices on the
  same LAN to establish direct connections, avoid going through the Tailscale relay.

This means VMs are allowed to open outgoing connections to:

- The Internet
- Tailscale

While the VM host itself, and my local LAN, are isolated from untrusted services.
