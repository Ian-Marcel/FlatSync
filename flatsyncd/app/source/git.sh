#!/usr/bin/env bash

# git config set --local
import git_config_default_values

if [ -d "$FLATSYNC_GIT"/.git ]; then
	cd "$FLATSYNC_GIT"
	if ! [ -e remote_flatpaks ]; then
		printf "Remote list not found! Is this you're first sync?"
		while true ; do
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
				git fetch -q
				git pull -q
				break
			else
				printf "Wrong answer, type either Yes or No! \n"
			fi
		done
	else
		git fetch -q
		git pull -q
	fi
else
	cd "$FLATSYNC_GIT"
	printf "Oh oh, sync repository not found! \nIs this you're first sync or would you like to import a sync repository?\n "
	while true; do
		read -rp "create(1) | import(2): " NO_REPO
		if [ "$NO_REPO" = 1 ]; then
			git init
			ssh-keygen -t ed25519 -f "$HOME"/.ssh/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
			for index in "${!git_preference[@]}"; do
				git config set --local "${git_preference[$index]}" "${git_preference_value[$index]}"
			done
			printf "Copy and paste the line bellow to your cloud git service:\n$(<"$HOME"/.ssh/flatsync_key.pub) \n"
			printf "\rPlease provide the repository url, make sure it is for SSH! \n"
			#while true; do
			read -rp "URL: " NR_GIT_ORIGIN
			# create: git_url_regex_funtion
			git remote add origin "$NR_GIT_ORIGIN" 
			#done
			break
		elif [ "$NO_REPO" = 2 ]; then
			printf "Ok..."
			sleep 1s
			break
		else
			printf "Wrong answer, type either 1 or 2! \n"
		fi
	done
	if [ "$NO_REPO" = 1 ]; then
			flatpak list --columns=application --app |
				tee -p remote_flatpaks &>/dev/null
			git add remote_flatpaks
			git commit -q -m "$(date "%H:%M:%S - %d/%m/%Y")"
			git push -q
			exit 0;
	elif [ "$NO_REPO" = 2 ]; then
			printf "\rPlease provide the repository url, make sure it is for SSH! \n"
		#while true; do
			read -rp "URL: " NR_GIT_ORIGIN
			# create: git_url_regex_funtion
			git clone "$NR_GIT_ORIGIN" "$FLATSYNC_GIT"/
		#done
		for index in "${!git_preference[@]}"; do
			if ! git config get --local "${git_preference[$index]}"; then
				git config set --local "${git_preference[$index]}" "${git_preference_value[$index]}"
			else
				continue
				sleep 1s
			fi
		done
	fi
fi
cd "$FLATSYNC_ROOT"

# git config set --local user.name 'flatsync'
# git config set --local user.email 'flatsync@fake.mail'
### Using SSH is one of the simplest—and most secure—ways to transfer Git data to hosting services such as GitHub, GitLab, Gitea, and others. Even if you choose not to protect your SSH key with a passphrase, SSH still provides robust security. For more details, see the official Git documentation on credential storage: https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage.
# ssh-keygen -t ed25519 -f ~/.ssh/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
### if key above not found, ask user to import it or create another
# git config set --local core.sshCommand 'ssh -o IdentitiesOnly=yes -i ~/.ssh/flatsync_key'
# git config set --local user.signingKey '~/.ssh/flatsync_key.pub'
# git config set --local gpg.format ssh
# git config set --local commit.gpgsign true

