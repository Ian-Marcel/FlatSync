#!/usr/bin/env bash

import git_config_default_values
import check_directories

check-dir_git
check-dir_ssh

foreach_git_config_set() {
	for index in "${!git_preference[@]}"; do
		if [ "$(git config --get --local "${git_preference[$index]}")" != "${git_preference_value[$index]}" ]; then
			git config --unset-all --local "${git_preference[$index]}"
			git config --add --local "${git_preference[$index]}" "${git_preference_value[$index]}"
		else
			continue
			sleep 1s
		fi
	done
}
clear
cd "$FLATSYNC_GIT" || exit

if [ -d "$FLATSYNC_GIT"/.git ]; then
	if ! [ -e remote_flatpaks ]; then
		printf "Remote list not found! Is this you're first sync?${NC}\n"
		shopt -s nocasematch
		while true; do
			read -rp "(Y)es | (N)o : " NO_LIST
			if [ "$NO_LIST" = Y ] || [ "$NO_LIST" = Yes ]; then
				flatpak list --columns=application --app |
					tee -p remote_flatpaks &>/dev/null
				git add remote_flatpaks
				git commit -q -m "$(date "%H:%M:%S - %d/%m/%Y")"
				git push -q
				exit 0
				break
			elif [ "$NO_LIST" = N ] || [ "$NO_LIST" = No ]; then
				git reset -q --hard origin/HEAD
				git fetch -q
				git pull -q
				break
			else
				printf "Wrong answer, type either Yes or No! ${NC}\n"
			fi
		done
		shopt -u nocasematch
	else
		printf "Updating repository\n"
		git fetch -q
		git pull -q
	fi
else
	printf "Oh oh, sync repository not found! \nIs this you're first sync or would you like to import a sync repository?${NC}\n"
	while true; do
		read -rp $'\033[1;32mcreate(1) \033[0m|\033[1;36m import(2) \033[0m: ' NO_REPO
		if [ "$NO_REPO" = 1 ]; then
			git init --initial-branch=main
			printf "${BYELLOW}SSH will be used for data transfering!${BGREEN} Here's the logicale:${NC}\n"
			printf "\tUsing SSH is one of the simplest — and most secure — ways to transfer Git data to hosting services such as GitHub, GitLab, Gitea, and others.
					\r\tEven if you choose not to protect your SSH key with a passphrase, SSH still provides robust security. For more details, see the official
					\r\tGit documentation on credential storage: ${BCYAN}https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage${NC}.
					\r${BYELLOW}The SSH key for Flatsync is created automatically without a password, ${BGREEN}but in the future it will be given you the choice of setting one for it. ${NC}\n"
			read -rp "Please read and understand the text above and then press ENTER to proceed " void
			clear
			if [ -e "$FLATSYNC_SSH"/flatsync_key ] && [ -e "$FLATSYNC_SSH"/flatsync_key.pub ]; then
				sleep 1
				printf "SSH key already exists! That's odd... \n"
			else
				ssh-keygen -t ed25519 -f "$FLATSYNC_SSH"/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
				printf "SSH key created!\n"
			fi
			printf "Copy you're public key in the line bellow and add to your repository hosting provider:
			\r${BGREEN}$(<"$FLATSYNC_SSH"/flatsync_key.pub)${NC}
			\rYou're not sure how to add it, here are some videos for adding to GitHub and GitLab:
			\rGitHub: ${BCYAN}https://youtu.be/iVJesFfzDGs?si=E4qserNj4-1jJuyy&t=54${NC}
			\rGitLab: ${BCYAN}https://youtu.be/mNtQ55quG9M?si=57nsYWVfpvd_4NfR&t=265${NC}\n"
			sleep 10
			read -rp $'\033[1;33mPress ENTER to proceed \033[0m' void
			clear
			foreach_git_config_set
			printf "\rPlease provide the repository url, make sure it is for SSH! ${NC}\n"
			read -rp "SSH URL [ex.: git@hosting.com:username/repository.git ]: " NR_GIT_ORIGIN
			#git_url_regex_funtion # comment.?
			git remote add origin "$NR_GIT_ORIGIN"
			break
		elif [ "$NO_REPO" = 2 ]; then
			printf "Ok..."
			sleep 2s
			break
		else
			printf "Wrong answer, type either 1 or 2! ${NC}\n"
		fi
	done
	if [ "$NO_REPO" = 1 ]; then
		flatpak list --columns=application --app |
			tee -p remote_flatpaks &>/dev/null
		git add remote_flatpaks
		git commit -q -m "$(date "%H:%M:%S - %d/%m/%Y")"
		git push -q -u origin main
		exit 0
	elif [ "$NO_REPO" = 2 ]; then
		if ! [ -e "$FLATSYNC_SSH"/flatsync_key ] && ! [ -e "$FLATSYNC_SSH"/flatsync_key.pub ]; then
			printf "SSH key not found! Wish to create a new or will you import one? \n"
			while true; do
				read -rp $'\033[1;32mcreate(1) \033[0m|\033[1;36m import(2) \033[0m: ' NO_SSH_KEY
				if [ "$NO_SSH_KEY" = 1 ]; then
					printf "Creating SSH key...\n"
					ssh-keygen -t ed25519 -f "$FLATSYNC_SSH"/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
					sleep 0.8s
					printf "SSH key created!\n"

					printf "Copy you're public key in the line bellow and add to your repository hosting provider:
					\r${BGREEN}$(<"$FLATSYNC_SSH"/flatsync_key.pub)${NC}\n"
					sleep 2
					read -rp $'\033[1;33mPress ENTER to proceed \033[0m' void
					clear

					break
				elif [ "$NO_SSH_KEY" = 2 ]; then
					printf "Please place your imported key under the following path:\n%s\n" "$FLATSYNC_SSH"
					sleep 1.4s

					while ! [ -e "$FLATSYNC_SSH"/flatsync_key ] && ! [ -e "$FLATSYNC_SSH"/flatsync_key.pub ]; do
						read -rp $'\033[1;33mPress ENTER to proceed \033[0m' void
						if ! [ -e "$FLATSYNC_SSH"/flatsync_key ] && ! [ -e "$FLATSYNC_SSH"/flatsync_key.pub ]; then
							printf "Error! Imported keys not found! Are you sure you placed them in the path above?\n"
						fi
						sleep 0.8s
					done
					printf "Done!\n"

					break
				else
					printf "Wrong answer, type either 1 or 2! ${NC}\n"
				fi
			done
		fi
		printf "\rPlease provide the repository url, make sure it is for SSH! ${NC}\n"
		read -rp "SSH URL [ex.: git@hosting.com:username/repository.git ]: " NR_GIT_ORIGIN
		#git_url_regex_funtion # comment.?
		git clone -q "$NR_GIT_ORIGIN" "$FLATSYNC_GIT"/ \
			--config="${git_preference[0]}"="${git_preference_value[0]}" \
			--config="${git_preference[1]}"="${git_preference_value[1]}" \
			--config="${git_preference[2]}"="${git_preference_value[2]}" \
			--config="${git_preference[3]}"="${git_preference_value[3]}" \
			--config="${git_preference[4]}"="${git_preference_value[4]}"
		foreach_git_config_set
	fi
fi
cd "$FLATSYNC_ROOT" || exit
