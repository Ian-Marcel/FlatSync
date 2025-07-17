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

- `--quiet` or `-q` : Hide standard output, errors are still shown.
  - Can be combined with `--auto` or `-a`.
- `--auto` or `-a` : Automatically performs (un)installations.
  - Can be combined with `--quiet` or `-q`.
- `--id=`, meant to be used alone with one of the options below. 
  - `make` : creates a identifier hash for your device, **requires** `sudo`.
  - `get` : shows you're ID for the current device.
- `--version` or `-v` : Shows FlatSync's version, meant to be used alone.

## RoadMap

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
