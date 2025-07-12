# FlatSync


Synchronize flatpak applications between devices.

- - -

## How it works:
1. Imagine that you have a laptop with Linux as the OS, it has the flatpaks apps A, B and C installed.
2. Now imagine you have a PC also with Linux as the OS, but it only have the app A installed.
- What FlatSync will do is that it will check the latest device and it will apply the changes to other devices.
3. In this example lets say you're laptop is the latest, so flatsync will see that both laptop and PC have app A installed, but the PC doesn't have app B and C, so it will install them in the PC, now both devices have the same apps!

## How to install

Simply copy the following command and paste it in your terminal:

```sh
curl -sSL https://from.ianmarcel.dev/install/flatsync | bash
```

### Updating
The previous command also detects whether `flatsync` is installed and performs an installation or update accordingly.

- You can check latest version notes at the [releases page](https://github.com/Ian-Marcel/FlatSync/releases/latest).

## Usage
```sh
flatsync [FLAGS]
```
### Flags available
- `--version | -v `: Shows FlatSync's version.
- `--auto | -a `: Automatically performs (un)installation.

## RoadMap
- [x] Addition of a `--version` flag
  - Very simple this one, it just tells you flatsync version installed in your device
- [x] Addition of a `--auto` flag
  - By default, if an aplication is set to be (un)installed, `flatsync` will list the list of applications to be operated and prompt the user to confirm the operation. With `--auto`, `flatsync` will no longer prompt the user for confirmation, (un)installing apps automatically, which is very useful for scheduled syncs.

- [ ] Addition of the `--quiet` flag
	- By default `flatsync` is quite verbose with which task is being run within the program at the time, even when running in the background(ex.: scheduled sync), for now, if you wish to omit standard output from `flatsync`, add `1>/dev/null` at the end of the command, it will still show error messages though. Here's an example:

		```sh 
		flatsync --auto 1>/dev/null
		```
- [ ] Support for exclusive applications on a single device
  - A persistent file named `exclusive` stores the names of these applications.
  - How it goes:
    1. During synchronization the system scans the `uninstall` file (if exists).
    2. If an application is found in both `exclusive` and `uninstall`, it is:
      	1. Removed from `uninstall`.
    3. It also be removed from the new `remote_flatpaks` after syncing.
- [ ] Support for custom remotes
	- By default, flathub is the main remote for downloading the apps, but in future will be able to rank the remotes of machine from the first to try to install to the last.
- - -

- [Code commentaries](docs/comments.md)

- [License - GNU GPL V3](LICENSE)
