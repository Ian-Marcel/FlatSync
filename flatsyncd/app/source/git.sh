#!/usr/bin/env bash

if [ -d "$FLATSYNC_GIT"/.git ]; then
	printf "OK\n"
else
	printf "Oh oh\n"
fi

