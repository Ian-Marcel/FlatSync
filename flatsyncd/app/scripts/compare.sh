#!/usr/bin/env bash

if ! [ -d "$FLATSYNC_CACHE" ]; then
	mkdir "$FLATSYNC_CACHE"
fi

set +e +u +o pipefail

flatpak list --columns=application --app |
	tee -p "$FLATSYNC_CACHE"/local_flatpaks &>/dev/null
mv "$FLATSYNC_GIT"/remote_flatpaks "$FLATSYNC_CACHE"/


# comment.2
if diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks | grep ">" &>/dev/null ; then
	diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks |
		grep ">" |
		awk -F ">" '{ print $2 }' |
		tee -p "$FLATSYNC_CACHE"/uninstall &>/dev/null
else
	sleep 1
fi

# comment.1
if diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks | grep "<" &>/dev/null ; then
	diff "$FLATSYNC_CACHE"/remote_flatpaks "$FLATSYNC_CACHE"/local_flatpaks |
		grep "<" |
		awk -F "<" '{ print $2 }' |
		tee -p "$FLATSYNC_CACHE"/install &>/dev/null
else
	sleep 1
fi

set -euo pipefail

