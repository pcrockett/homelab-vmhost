#!/usr/bin/env blarg

depends_on core/curl-installed core/sq-installed core/with-umask-installed images-dir-created

DEST_ISO="${LIBVIRT_IMAGES_DIR}/archlinux-x86_64.iso"

satisfied_if() {
  checkpoint_is_current
}

apply() {
  temp_dir="$(mktemp --directory)"

  # shellcheck disable=SC2329  # cleanup will be called automatically on exit
  cleanup() {
    rm -rf "${temp_dir}"
  }
  trap 'cleanup' EXIT

  curl_download https://mirror.thereisno.page/archlinux/iso/latest/archlinux-x86_64.iso \
    >"${temp_dir}/archlinux-x86_64.iso"
  curl_download https://mirror.thereisno.page/archlinux/iso/latest/archlinux-x86_64.iso.sig \
    >"${temp_dir}/archlinux-x86_64.iso.sig"

  sq verify \
    --signer-file "${REPO_CONFIG_DIR}/archlinux/release-key.asc" \
    --signature-file "${temp_dir}/archlinux-x86_64.iso.sig" \
    "${temp_dir}/archlinux-x86_64.iso"

  as_root with-umask u=rw,g=,o= cp "${temp_dir}/archlinux-x86_64.iso" "${DEST_ISO}"
  checkpoint_success
}
