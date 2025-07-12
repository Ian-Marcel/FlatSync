#!/usr/bin/env bash

import check_directories

check-dir_cache

set +e +u +o pipefail

if [ -e "$FLATSYNC_GIT"/last_updated_device ] && [ "$(<"$FLATSYNC_GIT"/last_updated_device)" = "$(</etc/hostname)" ]; then

	flatpak list --columns=application --app |
		tee -p "$FLATSYNC_GIT"/remote_flatpaks &>/dev/null
	if [ -d "$FLATSYNC_GIT"/overrides ]; then
		rm -rf "$FLATSYNC_GIT"/overrides
	fi
	cp -aT "$HOME"/.local/share/flatpak/overrides "$FLATSYNC_GIT"/overrides

else
	flatpak list --columns=application --app |
		tee -p "$FLATSYNC_CACHE"/local_flatpaks &>/dev/null
	mv "$FLATSYNC_GIT"/remote_flatpaks "$FLATSYNC_CACHE"/

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
