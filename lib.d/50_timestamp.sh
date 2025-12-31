file_timestamp() {
  # get last modified timestamp for a file
  # (integer seconds since epoch)
  stat --format %Y "${1}"
}
