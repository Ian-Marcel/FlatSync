#!/usr/bin/env bash

import appid_regex

printf "Processing installation data...\n"
for appid in $(<"$FLATSYNC_CACHE"/install); do
	installid+=("$appid")
done

total="${#installid[@]}"
for index in "${!installid[@]}"; do
	appid=${installid[$index]}

	progress_bar_by_task_completion "$index" "$total"
	appid_regex
	printf " ${BGREEN}+${NC} %s: %s \n" \
		"$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)" \
		"$(flatpak search --columns=description "$appid" | head -n "$i" | tail -n 1)" |
		tee -pa "$FLATSYNC_CACHE"/install-notice.tmp &>/dev/null
	install2+=("$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)")
done

printf "${BGREEN}To be installed:${NC}\n"
sleep 1s
cat "$FLATSYNC_CACHE"/install-notice.tmp
shred -u "$FLATSYNC_CACHE"/install-notice.tmp
ASWR="y"
read -rp "Proceed? [y/n]: " ASWR

if [ $ASWR = y ]; then
	for index in "${!install2[@]}"; do

		appid=${installid[$index]}
		app_name=${install2[$index]}

		flatpak install --noninteractive flathub "$appid" &>/dev/null &
		wait_with_spinner_loading "$app_name"

	done
else
	sleep 1
fi
