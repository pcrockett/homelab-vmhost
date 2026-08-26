#!/usr/bin/env blarg

depends_on incus-group-configured packages-installed incus-storage-initialized

satisfied_if() {
  checkpoint_is_current
}

apply() {
  incus admin init --preseed <"${REPO_CONFIG_DIR}/incus/init.yaml"
  checkpoint_success
}
