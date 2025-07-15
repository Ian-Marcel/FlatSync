#!/usr/bin/env bash

import check_directories

check-dir_cache

set +e +u +o pipefail

if [ -e "$FLATSYNC_GIT"/last_updated_device ] && { [ "$(head "$FLATSYNC_GIT"/last_updated_device -n 1)" = "$(cat /etc/hostname)" ] && [ "$(tail "$FLATSYNC_GIT"/last_updated_device -n 1)" = "$(cat /etc/machine-id | sha256sum | awk '{ print $1 }')" ]; }; then

	silencer_check printf "Same device!\n"
	NO_TODO=2
	source "$FLATSYNC_SCRIPT"/exit.sh

else

	silencer_check printf "Different device!\n"

	flatpak list --columns=application --app |
		tee -p "$FLATSYNC_CACHE"/local_flatpaks &>/dev/null
	cp "$FLATSYNC_GIT"/remote_flatpaks "$FLATSYNC_CACHE"/

	# comment.2
	if diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks | grep ">" &>/dev/null; then
		diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks |
			grep ">" |
			awk -F ">" '{ print $2 }' |
			tee -p "$FLATSYNC_CACHE"/uninstall &>/dev/null
	else
		sleep 1
	fi

	# comment.1
	if diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks | grep "<" &>/dev/null; then
		diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks |
			grep "<" |
			awk -F "<" '{ print $2 }' |
			tee -p "$FLATSYNC_CACHE"/install &>/dev/null
	else
		sleep 1
	fi

fi

set -euo pipefail
