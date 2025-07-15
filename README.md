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

### Installing from source or a pre-release
1. Remove current Flatsync installation:
    ```shell
    sudo rm -rf /usr/{local/bin,share}/flatsync
    ```
2. If you want to test a pre-release clone FlatSync repository on branch `stable`, if you're installing from source download `FlatSync.tar.gz` from the [release page](https://github.com/Ian-Marcel/FlatSync/releases) and extract it.

    ```sh
    wget https://github.com/Ian-Marcel/FlatSync/releases/download/<VERSION>/FlatSync.tar.gz
    # Or
    git clone --branch=stable https://github.com/Ian-Marcel/FlatSync.git
    ```
3. Then rename the folder `app/` to `flatsync/` and place it inside `/usr/share/` directory:

    ```sh
    sudo mv FlatSync/app /usr/share/flatsync
    ```
4. Finally, install `flatsync` command inside `/usr/local/bin/`:

    ```sh
    sudo install -o root -g root -m 0755 FlatSync/flatsync /usr/local/bin/flatsync
    ```

## Usage

```sh
flatsync [FLAGS]
```

### Flags available

- `--version` or `-v` : Shows FlatSync's version, meant to be used alone.
- `--auto` or `-a` : Automatically performs (un)installations.
  - Can be combined with `--quiet` or `-q`.
- `--quiet` or `-q` : Hide standard output, errors are still shown.
  - Can be combined with `--auto` or `-a`.

## RoadMap

#### ✅ [MINOR] Addition of a `--version` flag
  - Very simple this one, it just tells you flatsync version installed in your device

#### ✅ [MINOR] Addition of a `--auto` flag
  - By default, if an aplication is set to be (un)installed, `flatsync` will list the list of applications to be operated and prompt the user to confirm the operation. With `--auto`, `flatsync` will no longer prompt the user for confirmation, (un)installing apps automatically, which is very useful for scheduled syncs.

#### ✅ [MINOR] Addition of the `--quiet` flag
- By default `flatsync` is quite verbose with which task is being run within the program at the time, even when running in the background(ex.: scheduled sync), for now, if you wish to omit standard output from `flatsync`, add `1>/dev/null` at the end of the command, it will still show error messages though.

#### ✅ [MINOR] Support for synchronization of user flatpak overrides.
- Flatsync will sync the folder `overrides` in `~/.local/share/flatpak` together with the list of apps.

#### ✅ [PATCH] Adding `machine_id` to `last_updated_device` for better distinguishing devices.
- FlatSync checks the device name before syncing, it stores the device name together with the list of apps, but there'a problem, if 2 or more devices have the same name, FlatSync will think that they're the same device, not syncing properly or/and worse, messing up with list of applications.

#### 🏁 [MAJOR] Support for exclusive applications on a single device
- A persistent file named `exclusive` stores the names of these applications.
- How it goes:
  1. During synchronization the system scans the `uninstall` file (if exists).
  2. If an application is found in both `exclusive` and `uninstall`, it is:
     1. Removed from `uninstall`.
     2. Removed from `install`.
     3. Removed from the new `remote_flatpaks` after syncing.

#### 🏁 [MAJOR] Support for custom remotes
- By default, flathub is the main remote for downloading the apps, but in future will be able to rank the remotes of machine from the first to try to install to the last.

- - -

- [Code commentaries](docs/comments.md)
- [License - GNU GPL V3](LICENSE)
