#!/usr/bin/env bash

shred -u "$FLATSYNC_CACHE"/*

cd "$FLATSYNC_GIT" || exit
flatpak list --columns=application --app |
	tee -p remote_flatpaks &>/dev/null
cat /etc/hostname | tee -p "$FLATSYNC_GIT"/last_updated_device &>/dev/null
git add .
if git commit -q -m "$(date "%H:%M:%S - %d/%m/%Y")" &>/dev/null; then
	git push -q
	cd "$FLATSYNC_ROOT" || exit
else
	cd "$FLATSYNC_ROOT" || exit
	exit 0
fi

