#!/usr/bin/env blarg

UNIT="automagical-backup.service"

depends_on backup-cli-installed backup-configured

satisfied_if() {
  test "$(systemctl is-enabled "${UNIT}")" = "enabled"
}

apply() {
  as_root backup automagic
}
