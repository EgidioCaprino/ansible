#!/usr/bin/env bash

systemctl restart keep_connection_alive.service

repository="/mnt/borg_repository"
mountDir="/mnt/egidiocaprino.com"

sshfs root@nextcloud.egidiocaprino.com:/ "${mountDir}"

ssh -l root nextcloud.egidiocaprino.com "docker stop nextcloud_app_1"
ssh -l root nextcloud.egidiocaprino.com "docker stop nextcloud_db_1"

timeout --kill-after 1m 3h borg create "${repository}"::var_lib_docker_volumes_nextcloud_db-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_db
timeout --kill-after 1m 3h borg create "${repository}"::var_lib_docker_volumes_nextcloud_nextcloud-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_nextcloud

ssh -l root nextcloud.egidiocaprino.com "docker start nextcloud_db_1"
ssh -l root nextcloud.egidiocaprino.com "docker start nextcloud_app_1"

umount "${mountDir}"

timeout --kill-after 1m 1h borg prune --prefix "var_lib_docker_volumes_nextcloud_db" --keep-last 30 "${repository}"
timeout --kill-after 1m 1h borg prune --prefix "var_lib_docker_volumes_nextcloud_nextcloud" --keep-last 30 "${repository}"
