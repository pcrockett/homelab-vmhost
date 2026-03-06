# shellcheck shell=bash

export PATH="${BLARG_MODULE_DIR}/bin:${PATH}"
export STATE_DIR="${HOME}/.local/state/vmhost"
export REPO_CONFIG_DIR="${BLARG_MODULE_DIR}/config"
export REPO_BIN_DIR="${BLARG_MODULE_DIR}/bin"

# default debian disk partition format only allows for a few gigs in `/var`.
# so we store our libvirt images under `/srv`, which is the bulk of our storage.
export LIBVIRT_IMAGES_DIR="/srv/libvirt/images"
