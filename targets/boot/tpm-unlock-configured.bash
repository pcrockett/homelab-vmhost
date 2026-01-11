#!/usr/bin/env blarg

depends_on clevis-installed

satisfied_if() {
  checkpoint_is_current
}

apply() {
  lsblk --filter 'TYPE == "crypt"' --output PKNAME --noheadings \
    | sort --unique \
    | while IFS= read -r device_name; do
      echo "${DISK_ENCRYPTION_PASSWORD}" | as_root clevis luks bind -k - -d "/dev/${device_name}" tpm2 '{}'
    done

  as_root update-initramfs -u -k all

  checkpoint_success
}
