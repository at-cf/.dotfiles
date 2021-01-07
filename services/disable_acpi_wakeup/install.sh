#! /bin/bash

set -e

[[ $EUID > 0 ]] && >&2 echo "Run as root" && exit 1

cp -rf disable_acpi_wakeup.service /etc/systemd/system/disable_acpi_wakeup.service

cp -rf disable_acpi_wakeup /usr/lib/systemd/scripts/disable_acpi_wakeup

chmod a+x /usr/lib/systemd/scripts/disable_acpi_wakeup

systemctl daemon-reload
systemctl enable disable_acpi_wakeup.service
systemctl start disable_acpi_wakeup.service
systemctl status disable_acpi_wakeup.service
