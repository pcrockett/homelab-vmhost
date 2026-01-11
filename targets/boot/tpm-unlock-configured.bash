#!/usr/bin/env blarg

depends_on clevis-installed core/with-umask-installed bitwarden/cli-installed

satisfied_if() {
  checkpoint_is_current
}

apply() {
  satisfy bitwarden/synced
  load_bw_item machine.lab01

  local disk_encryption_password
  disk_encryption_password="$(bw_value disk.encryption.password)"

  lsblk --filter 'TYPE == "crypt"' --output PKNAME --noheadings \
    | sort --unique \
    | while IFS= read -r device_name; do
      echo "${disk_encryption_password}" | as_root clevis luks bind -k - -d "/dev/${device_name}" tpm2 '{}'
    done

  as_root update-initramfs -u -k all

  checkpoint_success
}
