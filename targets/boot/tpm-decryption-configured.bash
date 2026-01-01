#!/usr/bin/env blarg

depends_on clevis-installed

satisfied_if() {
  false
}

apply() {
  # I would use `systemd-cryptenroll`, however the TPM device on the HP Spectre x360
  # is old enough that it doesn't support AES-128-CFB (which systemd requires).
  #
  # Which is sad. Because I created this BEAUTIFUL bit of code to handle it for me:
  #
  #     lsblk --filter 'TYPE == "crypt"' --output PKNAME --noheadings \
  #       | sort --unique \
  #       | xargs -L1 printf '/dev/%s\n' \
  #       | as_root PASSWORD="${DISK_ENCRYPTION_PW}" xargs -L1 systemd-cryptenroll --tpm2-device=auto
  #
  # Anyway, let's fall back to clevis.

  temp_dir="$(mktemp -d)"
  cleanup() {
    rm -rf "${temp_dir}"
  }
  trap 'cleanup' EXIT

  password_file="${temp_dir}/luks-pw"
  echo -n "${DISK_ENCRYPTION_PW}" >"${password_file}"

  lsblk --filter 'TYPE == "crypt"' --output PKNAME --noheadings \
    | sort --unique \
    | while IFS= read -r device_name; do
      as_root clevis luks bind -k "${password_file}" -d "/dev/${device_name}" tpm2 '{}'
    done

  as_root update-initramfs -u -k all
}
