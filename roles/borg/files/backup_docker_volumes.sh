#!/usr/bin/env bash

repository="/mnt/borg_repository"
mountDir="/mnt/egidiocaprino.com"

sshfs root@egidiocaprino.com:/ "${mountDir}"

ssh -l root egidiocaprino.com "docker stop drone_server"
borg create "${repository}"::var_lib_drone-{now:%Y-%m-%d} "${mountDir}"/var/lib/drone
ssh -l root egidiocaprino.com "docker start drone_server"

ssh -l root egidiocaprino.com "docker stop nextcloud_app_1"
ssh -l root egidiocaprino.com "docker stop nextcloud_db_1"

borg create "${repository}"::var_lib_docker_volumes_nextcloud_db-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_db
borg create "${repository}"::var_lib_docker_volumes_nextcloud_nextcloud-{now:%Y-%m-%d} "${mountDir}"/var/lib/docker/volumes/nextcloud_nextcloud

ssh -l root egidiocaprino.com "docker start nextcloud_db_1"
ssh -l root egidiocaprino.com "docker start nextcloud_app_1"

umount "${mountDir}"
