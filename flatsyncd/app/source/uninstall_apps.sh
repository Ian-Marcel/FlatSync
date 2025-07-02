#!/usr/bin/env bash

printf "Processing uninstallation data...\n"
for appid in $(<"$FLATSYNC_CACHE"/uninstall); do
	uninstallid+=("$appid")
done

total="$((${#uninstallid[@]} - 1))"
for index in "${!uninstallid[@]}"; do
	appid=${uninstallid[$index]}

	progress_bar_by_task_completion "$index" "$total"
	printf "\b ${BRED}-${NC} $(flatpak search --columns=name $appid | head -n1 ): " |
		tee -pa "$FLATSYNC_CACHE"/uninstall-notice.tmp &> /dev/null
	printf "$(flatpak search --columns=description $appid | head -n1 )\n" |
		tee -pa "$FLATSYNC_CACHE"/uninstall-notice.tmp &> /dev/null
	uninstall2+=("$(flatpak search --columns=name $appid | head -n1 )")
done

printf "${BRED}To be uninstalled:${NC}\n"
sleep 1s;
cat "$FLATSYNC_CACHE"/uninstall-notice.tmp
shred -u "$FLATSYNC_CACHE"/uninstall-notice.tmp
ASWR="y"
read -rp "Proceed? [y/n]: " ASWR

if [ $ASWR = y ]; then
	for index in "${!uninstall2[@]}"; do
		set -euo pipefail
		trap 'printf "❌ \033[1;31m\b Error occurred! \033[1;33m\b Exiting...\033[0m\n" && exit 1' ERR

		appid=${uninstallid[$index]}
		app_name=${uninstall2[$index]}

		flatpak uninstall --noninteractive "$appid" &>/dev/null & 
		wait_with_spinner_loading "$app_name"

	done
else
	sleep 1
fi

