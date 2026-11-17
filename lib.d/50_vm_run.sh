# shellcheck shell=bash

vm_run() {
  incus exec "${VM_NAME:?Missing variable}" -- "$@"
}
