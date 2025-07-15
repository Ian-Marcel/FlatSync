#!/usr/bin/env bash

if [ "$NO_TODO" -lt 2 ]; then
	for old_items in "$FLATSYNC_CACHE"/*; do
		shred -u "$old_items"
	done
fi

cd "$FLATSYNC_GIT" || exit

flatpak list --columns=application --app |
	tee -p remote_flatpaks &>/dev/null
if [ -d "$FLATSYNC_GIT"/overrides ]; then
	rm -rf "$FLATSYNC_GIT"/overrides
fi
cp -aT "$HOME"/.local/share/flatpak/overrides "$FLATSYNC_GIT"/overrides
printf "%s\n%s" "$(cat /etc/hostname)" "$(cat /etc/machine-id | sha256sum | awk '{ print $1 }')" |
	tee -p ./last_updated_device 1>/dev/null

git add .
if git commit -q -m "$(date "%H:%M:%S - %d/%m/%Y")" &>/dev/null; then
	git push -q
else
	exit 0
fi
exit 0
