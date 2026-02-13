#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: portscan.sh SCAN_TARGET [PROTOCOL]

Scan your server's open ports.

Parameters:

  SCAN_TARGET: IP address or hostname
  PROTOCOL: Either TCP or UDP. Defaults to TCP.

Environment variables:

  PORT_RANGE: Defaults to '1-1024' if not specified
  TIMING: Defaults to 'aggressive'
EOF
}

panic_with_usage() {
  echo "FATAL: $*"
  echo
  usage
  exit 1
}

init() {
  PORT_RANGE="${PORT_RANGE:-"1-1024"}"
  TIMING="${TIMING:-aggressive}"
  SCAN_TARGET="${1:-}"
  PROTOCOL="${2:-tcp}"

  if [ "${SCAN_TARGET}" = "" ]; then
    panic_with_usage "Missing SCAN_TARGET parameter."
  fi
}

main() {
  init "$@"

  # nmap parameters:
  #
  # `-sU` or `-sT`: Do UDP or TCP scans
  # `-Pn`: Assume the host is up. Don't try to detect whether it's online.
  # `-A`: Do OS / version detection, use scanning scripts.
  # `-pT:0-1024,U:0-1024`: Scan ports 0-1024, both UDP and TCP
  # `--reason`: Display why a port was open / closed / filtered (i.e. "no-response")
  # `-T normal`: "normal" timing. Options are paranoid|sneaky|polite|normal|aggressive|insane
  # `-v`: Verbose. Display progress. Can do `-vv` instead if that's not enough.

  scan_command=(
    nmap -Pn -A --reason -T "${TIMING}" -v
  )

  case "${PROTOCOL}" in
    TCP|tcp)
      scan_command+=(-sT "-pT:${PORT_RANGE}")
      ;;
    UDP|udp)
      scan_command=(sudo "${scan_command[@]}" -sU "-pU:${PORT_RANGE}")
      ;;
    *)
      panic_with_usage "Expected PROTOCOL to be either TCP or UDP. Got '${PROTOCOL}'."
      ;;
  esac

  "${scan_command[@]}" "${SCAN_TARGET}"
}

main "$@"
