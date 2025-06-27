#!/usr/bin/env bash

# git config set --local
import data/git
if [ -d "$FLATSYNC_GIT"/.git ]; then
	cd "$FLATSYNC_GIT"
	for index in "${!git_preference[@]}"; do
		if ! git config get --local "${git_preference[$index]}"; then
			git config set --local "${git_preference[$index]}" "${git_preference_value[$index]}"
		else
			continue
			sleep 1s
		fi
	done
else
	printf "Oh oh\n"
	cd "$FLATSYNC_GIT"
	git init
fi

# git config set --local user.name 'flatsync'
# git config set --local user.email 'flatsync@fake.mail'
### Using SSH is one of the simplest—and most secure—ways to transfer Git data to hosting services such as GitHub, GitLab, Gitea, and others. Even if you choose not to protect your SSH key with a passphrase, SSH still provides robust security. For more details, see the official Git documentation on credential storage: https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage.
# ssh-keygen -t ed25519 -f ~/.ssh/flatsync_key -q -N "" -C "SSH key for Flatsync - a synchronizer for flatpak applications"
### if key above not found, ask user to import it or create another
# git config set --local core.sshCommand 'ssh -o IdentitiesOnly=yes -i ~/.ssh/flatsync_key'
# git config set --local user.signingKey '~/.ssh/flatsync_key.pub'
# git config set --local gpg.format ssh
# git config set --local commit.gpgsign true

# the following if statement works(it will print "Not found!" if gpg.format is unset): `if ! git config get --local gpg.format &> /dev/null ; then printf "Not found! \n";fi`
# if var=Hello, `printf "\"$var"\"` will print "Hello"(with the commas)
