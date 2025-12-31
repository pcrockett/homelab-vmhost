# shellcheck shell=bash

__TEMPLATE_EXTENSION=".template"

__validate_template_file_name() {
  local regex="\\${__TEMPLATE_EXTENSION}\$"
  [[ "${1}" =~ ${regex} ]] || panic "Template name must have a ${__TEMPLATE_EXTENSION} extension."
}

__get_template_output_file() {
  local template="${1}" output_dir output
  output_dir="$(dirname "${template}")"
  output="${output_dir}/$(basename "${template}" "${__TEMPLATE_EXTENSION}")"
  echo "${output}"
}

template_was_rendered() {
  # returns zero exit code when template is older than its output
  # returns non-zero exit code when template is newer than its output
  local template="${1}" output output_modified template_modified
  __validate_template_file_name "${template}"
  output="$(__get_template_output_file "${template}")"
  test -f "${output}" || return 1
  output_modified="$(file_timestamp "${output}")"
  template_modified="$(file_timestamp "${template}")"
  test "${template_modified}" -lt "${output_modified}"
}

template_render() {
  local template="${1}" mask="${2:-u=rw,g=,o=}" output
  __validate_template_file_name "${template}"
  output="$(__get_template_output_file "${template}")"
  with-umask "${mask}" envsubst <"${template}" >"${output}"
}
