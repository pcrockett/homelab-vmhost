# define the following before rendering this snippet:
#
# * PACKAGES: bash array of package names
#

satisfied_if() {
  package_is_installed "${PACKAGES[@]}"
}

apply() {
  satisfy core/apt-updated
  install_package "${PACKAGES[@]}"
}
