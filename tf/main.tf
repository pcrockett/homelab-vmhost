resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  target = {
    path = "/var/lib/libvirt/images"
  }
}

resource "libvirt_volume" "gis_workstation" {
  name     = "gis_workstation.qcow2"
  pool     = resource.libvirt_pool.default.name
  capacity = 42949672960 # 40 GiB
  target   = {
    type = "qcow2"
  }
}

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
            file = resource.libvirt_volume.gis_workstation.path
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

    graphics = [
      {
        spice = {
          port = 5900
          listeners = [
            { address = { address = "127.0.0.1" } }
          ]
        }
      }
    ]
  }
}
