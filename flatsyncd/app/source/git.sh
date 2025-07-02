#!/usr/bin/env bash

shopt -s nocasematch
# git config set --local
import git_config_default_values
foreach_git_config_set() {
	if [ "$1" = 'not_ok' ]; then
		for index in "${!git_preference[@]}"; do
			if ! git config get --local "${git_preference[$index]}"; then
				git config set --local "${git_preference[$index]}" "${git_preference_value[$index]}"
			else
				continue
				sleep 1s
			fi
		done
	elif [ "$1" = 'ok' ]; then
		for index in "${!git_preference[@]}"; do
			git config set --local "${git_preference[$index]}" "${git_preference_value[$index]}"
		done
	fi
}

if [ -d "$FLATSYNC_GIT"/.git ]; then
	cd "$FLATSYNC_GIT" || exit
	if ! [ -e remote_flatpaks ]; then
		printf "Remote list not found! Is this you're first sync?${NC}\n"
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
				git fetch -q
				git reset -q --hard origin/HEAD
				git pull -q
				break
			else
				printf "Wrong answer, type either Yes or No! ${NC}\n"
			fi
		done
	else
		printf "Updating repository\n"
		git fetch -q
		git pull -q
	fi
else
	cd "$FLATSYNC_GIT" || exit
	printf "Oh oh, sync repository not found! \nIs this you're first sync or would you like to import a sync repository?${NC}\n"
	while true; do
		read -rp "create(1) | import(2): " NO_REPO
		if [ "$NO_REPO" = 1 ]; then
			git init --initial-branch=main
			printf "${BYELLOW}SSH will be used for data transfering!${BGREEN} Here's the logicale:${NC}\n"
			printf "\tUsing SSH is one of the simplest — and most secure — ways to transfer Git data to hosting services such as GitHub, GitLab, Gitea, and others.
					\r\tEven if you choose not to protect your SSH key with a passphrase, SSH still provides robust security. For more details, see the official
					\r\tGit documentation on credential storage: ${BCYAN}https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage${NC}.
					\r${BYELLOW}The SSH key for Flatsync is created automatically without a password, in the future it will be given you the choice of setting one for it. ${NC}\n"
			read -rp "Please read the text above and then hit ENTER to proceed " void
			clear
			if [ -e "$HOME"/.ssh/flatsync_key ] && [ -e "$HOME"/.ssh/flatsync_key.pub ]; then
				sleep 1
				printf "SSH key already exists! That's odd... \n"
			else
				ssh-keygen -t ed25519 -f "$HOME"/.ssh/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
				printf "SSH key created!\n"
			fi
			printf "Copy you're public key in the line bellow and add to your repository hosting provider:
			\r${BGREEN}$(<"$HOME"/.ssh/flatsync_key.pub)${NC}
			\rYou're not sure how to add it, here are some videos for adding to GitHub and GitLab:
			\rGitHub: ${BCYAN}https://youtu.be/iVJesFfzDGs?si=E4qserNj4-1jJuyy&t=54${NC}
			\rGitLab: ${BCYAN}https://youtu.be/mNtQ55quG9M?si=57nsYWVfpvd_4NfR&t=265${NC}\n"
			sleep 10
			read -rp $'\033[1;33mHit ENTER to proceed \033[0m' void
			clear
			foreach_git_config_set ok
			printf "\rPlease provide the repository url, make sure it is for SSH! ${NC}\n"
			#while true; do
			read -rp "URL: " NR_GIT_ORIGIN
			# create: git_url_regex_funtion
			git remote add origin "$NR_GIT_ORIGIN"
			#done
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
		printf "\rPlease provide the repository url, make sure it is for SSH! ${NC}\n"
		#while true; do
		read -rp "URL: " NR_GIT_ORIGIN
		# create: git_url_regex_funtion
		git clone "$NR_GIT_ORIGIN" "$FLATSYNC_GIT"/
		#done
		foreach_git_config_set not_ok
	fi
fi
cd "$FLATSYNC_ROOT" || exit

shopt -u nocasematch
# git config set --local user.name 'flatsync'
# git config set --local user.email 'flatsync@fake.mail'
### Using SSH is one of the simplest—and most secure—ways to transfer Git data to hosting services such as GitHub, GitLab, Gitea, and others. Even if you choose not to protect your SSH key with a passphrase, SSH still provides robust security. For more details, see the official Git documentation on credential storage: https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage.
# ssh-keygen -t ed25519 -f ~/.ssh/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
### if key above not found, ask user to import it or create another
# git config set --local core.sshCommand 'ssh -o IdentitiesOnly=yes -i ~/.ssh/flatsync_key'
# git config set --local user.signingKey '~/.ssh/flatsync_key.pub'
# git config set --local gpg.format ssh
# git config set --local commit.gpgsign true
