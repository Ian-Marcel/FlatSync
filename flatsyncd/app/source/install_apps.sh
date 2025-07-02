#!/usr/bin/env bash

printf "Processing installation data...\n"
for appid in $(<"$FLATSYNC_CACHE"/install); do
	installid+=("$appid")
done

total="$((${#installid[@]} - 1))"
for index in "${!installid[@]}"; do
	appid=${installid[$index]}

	progress_bar_by_task_completion "$index" "$total"
	printf "\b ${BGREEN}+${NC} $(flatpak search --columns=name $appid | tr -d "\n"): " |
		tee -pa "$FLATSYNC_CACHE"/install-notice.tmp &> /dev/null
	printf "$(flatpak search --columns=description $appid | tr -d "\n")\n" |
		tee -pa "$FLATSYNC_CACHE"/install-notice.tmp &> /dev/null
	install2+=("$(flatpak search --columns=name $appid | tr -d "\n")")

done

printf "${BGREEN}To be installed:${NC}\n"
sleep 1s;
cat "$FLATSYNC_CACHE"/install-notice.tmp
shred -u "$FLATSYNC_CACHE"/install-notice.tmp
ASWR="y"
read -rp "Proceed? [y/n]: " ASWR

if [ $ASWR = y ]; then
	for index in "${!install2[@]}"; do
		set -euo pipefail
		trap 'printf "❌ \033[1;31m\b Error occurred! \033[1;33m\b Exiting...\033[0m\n" && exit 1' ERR

		appid=${installid[$index]}
		app_name=${install2[$index]}

		flatpak install --noninteractive "$appid" & 
		wait_with_spinner_loading "$app_name"

	done
else
	sleep 1
fi

