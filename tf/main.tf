resource "libvirt_domain" "gis_workstation" {
  name = "gis"
  memory = 4096
  memory_unit = "MiB"
  vcpu = 4
  type = "kvm"
  autostart = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    boot_devices = [{dev = "hd"}]
  }

  devices = {

    disks = [
      {
        source = {
          file = {
            file = "/var/lib/libvirt/images/gis_workstation.qcow2"
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      }
    ]

    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "default"
          }
        }
      }
    ]
  }
}
