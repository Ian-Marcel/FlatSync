#!/usr/bin/env bash

#printf "Checking data directory...\n"
if [ -d "$FLATSYNC_DATA" ]; then
	#printf "Found! Now checking child directories...\n"
	for dir in "$FLATSYNC_DATA"/{git,cache,app/{source,import}}; do
		if [ -d "$dir" ]; then
			#printf "$(basename "$dir") - OK\n"
			continue
			sleep 1
		else
			#printf "$(basename "$dir") - NOT OK: Creating\n"
			mkdir -p "$dir"
		fi
	done
else
	#printf "Not found! Creating...\n"
	mkdir -p "$FLATSYNC_DATA"/{git,app/{source,cache}}
fi

