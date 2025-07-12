#!/usr/bin/env bash

import appid_regex

silencer_check printf "Processing uninstallation data...\n"
for appid in $(<"$FLATSYNC_CACHE"/uninstall); do
	uninstallid+=("$appid")
done

if [ "${#uninstallid[@]}" -eq 1 ]; then
	total=${#uninstallid[@]}
else
	total=$((${#uninstallid[@]} - 1))
fi

for index in "${!uninstallid[@]}"; do
	appid=${uninstallid[$index]}

	progress_bar_by_task_completion "$index" "$total"
	appid_regex
	printf " ${BRED}-${NC} %s: %s \n" \
		"$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)" \
		"$(flatpak search --columns=description "$appid" | head -n "$i" | tail -n 1)" |
		tee -pa "$FLATSYNC_CACHE"/uninstall-notice.tmp &>/dev/null
	uninstall2+=("$(flatpak search --columns=name "$appid" | head -n "$i" | tail -n 1)")
done

silencer_check printf "${BRED}To be uninstalled:${NC}\n"
sleep 1s
silencer_check cat "$FLATSYNC_CACHE"/uninstall-notice.tmp
shred -u "$FLATSYNC_CACHE"/uninstall-notice.tmp
ASWR="y"
if [ "$AUTO_OP_FLATPAKS" = 0 ]; then
	read -rp "Proceed? [y/n]: " ASWR
fi

if [ $ASWR = y ]; then
	for index in "${!uninstall2[@]}"; do

		appid=${uninstallid[$index]}
		app_name=${uninstall2[$index]}

		flatpak uninstall --noninteractive --assumeyes "$appid" &>/dev/null &
		silencer_check wait_with_spinner_loading "$app_name"

	done
else
	sleep 1
fi
