#!/usr/bin/env bash

profile="home"

# Found this warning:
# Warning: The unit file, source configuration file or drop-ins of netctl@home.service changed on disk
systemctl daemon-reload

exitCode=$(netctl status "${profile}" > /dev/null)
if [ "${exitCode}" -ne 0 ]; then
    netctl restart "${profile}"
fi
