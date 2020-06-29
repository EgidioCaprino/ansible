#!/usr/bin/env bash

profile="home"

netctl status "${profile}" > /dev/null
if [ $? -ne 0 ]; then
    netctl restart "${profile}"
fi
