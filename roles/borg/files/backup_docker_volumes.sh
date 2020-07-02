#!/usr/bin/env bash

systemctl restart keep_connection_alive.service

repository="/mnt/borg_repository"
mountDir="/mnt/egidiocaprino.com"

sshfs root@egidiocaprino.com:/ "${mountDir}"

ssh -l root egidiocaprino.com "docker stop drone_server"
timeout --kill-after 1m 1h borg create "${repository}"::var_lib_drone-{now:%Y-%m-%d} "${mountDir}"/var/lib/drone
ssh -l root egidiocaprino.com "docker start drone_server"

ssh -l root egidiocaprino.com "docker stop nextcloud_app_1"
ssh -l root egidiocaprino.com "docker stop nextcloud_db_1"

timeout --kill-after 1m 3h borg create "${repository}"::var_lib_docker_volumes_nextcloud_db-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_db
timeout --kill-after 1m 3h borg create "${repository}"::var_lib_docker_volumes_nextcloud_nextcloud-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_nextcloud

ssh -l root egidiocaprino.com "docker start nextcloud_db_1"
ssh -l root egidiocaprino.com "docker start nextcloud_app_1"

umount "${mountDir}"
