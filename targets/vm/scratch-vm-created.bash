#!/usr/bin/env blarg
#
# provision a disposable VM
#

depends_on incus-initialized

VM_NAME=scratch
CPU_COUNT=2
MEMORY=2GiB
ROOT_DISK_SIZE=50GiB

satisfied_if() {
  incus info "${VM_NAME}"
}

apply() {
  incus create images:archlinux "${VM_NAME}" \
    --vm \
    --config limits.cpu="${CPU_COUNT}" \
    --config limits.memory="${MEMORY}" \
    --config security.secureboot=false \
    --device root,size="${ROOT_DISK_SIZE}" \
    --device root,io.bus=nvme

  # - `io.bus=virtio-scsi` is the default. it crashes something important in our
  #   virtualization stack.
  # - `io.bus=virtio-blk` seems to _delay_ the crash, but it certainly doesn't fix it.
  # - `io.bus=nvme` seems to at least survive the coolify install process, but the
  #   upgrade at the end times out waiting for containers to start.
  #
  # UNFORTUNATELY because of this io bus change, `incus-growpart.service` inside the
  # VM crashes because it's looking for `/dev/sda2`, but under this driver it's called
  # `/dev/nvme0n1p2`. so TODO here: patch that service file to get this working. it
  # should end up like:
  #
  #     [Unit]
  #     Description=Incus - grow root partition

  #     [Service]
  #     Type=oneshot
  #     ExecStartPre=-/usr/sbin/growpart /dev/nvme0n1 2
  #     ExecStart=/usr/sbin/resize2fs /dev/nvme0n1p2

  #     [Install]
  #     WantedBy=default.target
  #
}
