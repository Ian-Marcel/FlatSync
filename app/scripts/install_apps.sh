#!/usr/bin/env bash

import appid_regex

silencer_check printf "Processing installation data...\n"
for appid in $(<"$FLATSYNC_CACHE"/install); do
	installid+=("$appid")
done

if [ "${#installid[@]}" -eq 1 ]; then
	total="${#installid[@]}"
else
	total=$((${#installid[@]} - 1))
fi

for index in "${!installid[@]}"; do
	appid=${installid[$index]}

	silencer_check progress_bar_by_task_completion "$index" "$total"
	appid_regex
	printf " ${BGREEN}+${NC} %s: %s \n" \
		"$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)" \
		"$(flatpak search --columns=description "$appid" | head -n "$i" | tail -n 1)" |
		tee -pa "$FLATSYNC_CACHE"/install-notice.tmp &>/dev/null
	install2+=("$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)")
done

silencer_check printf "${BGREEN}To be installed:${NC}\n"
sleep 1s
silencer_check cat "$FLATSYNC_CACHE"/install-notice.tmp
shred -u "$FLATSYNC_CACHE"/install-notice.tmp
ASWR="y"
if [ "$AUTO_OP_FLATPAKS" = 0 ]; then
	read -rp "Proceed? [y/n]: " ASWR
fi

if [ $ASWR = y ]; then
	for index in "${!install2[@]}"; do

		appid=${installid[$index]}
		app_name=${install2[$index]}

		flatpak install --noninteractive --assumeyes flathub "$appid" &>/dev/null &
		silencer_check wait_with_spinner_loading "$app_name"

	done
else
	sleep 1
fi
