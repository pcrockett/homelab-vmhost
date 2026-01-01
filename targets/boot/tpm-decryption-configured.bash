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
  #       | xargs printf '/dev/%s\n' \
  #       | as_root PASSWORD="${DISK_ENCRYPTION_PW}" xargs systemd-cryptenroll --tpm2-device=auto
  #
  # Anyway, let's fall back to clevis.
  panic "Work in progress"
}
