#!/usr/bin/env blarg

depends_on core/with-umask-installed

satisfied_if() {
  checkpoint_is_current
}

apply() {
  as_root with-umask u=rwx,g=,o= mkdir --parent "${LIBVIRT_IMAGES_DIR}"
  checkpoint_success
}
