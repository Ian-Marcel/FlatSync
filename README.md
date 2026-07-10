# FlatSync


Synchronize flatpak applications between _Linux_ devices through **Git**.

- - -

## How it works:

1. Imagine that you have a laptop with Linux as the OS, it has the flatpaks apps A, B and C installed.
2. Now imagine you have a PC also with Linux as the OS, but it only have the app A installed.
- What FlatSync will do is that it will check the latest device and it will apply the changes to other devices.
3. In this example lets say you're laptop is the latest, so flatsync will see that both laptop and PC have app A installed, but the PC doesn't have app B and C, so it will install them in the PC, now both devices have the same apps!

## How to install

Simply copy the following command and paste it in your terminal:

```sh
curl -fsSL https://from.ianmarcel.dev/install/flatsync | env bash
```

To test the experimental version use:

```sh
curl -fsSL https://from.ianmarcel.dev/install/flatsync | EXPERIMENTAL=true env bash
```

### Updating
The previous command also detects whether `flatsync` is installed and performs an installation or update accordingly.

- You can check latest version notes at the [releases page](https://github.com/Ian-Marcel/FlatSync/releases/latest).

### Uninstall
Just run the following command and it will remove flatsync objects:
```sh
curl -fsSL https://from.ianmarcel.dev/uninstall/flatsync | env sh
```

## Usage

```sh
flatsync [FLAGS]
```

### Flags

* `--automatic`, `-a`
  Automatically and silently performs Flatpak installations and removals.

* `--systemd <minutes>`, `-S <minutes>`
  Creates and enables a user-level `systemd` timer for FlatSync.

  The timer automatically runs FlatSync every `<minutes>`.
  Default interval is **10 minutes**.

  **Example:**

  ```sh
  flatsync -S 15
  # Runs FlatSync automatically every 15 minutes
  ```

  This creates:

  ```text
  ~/.config/systemd/user/flatsync.service
  ~/.config/systemd/user/flatsync.timer
  ```

* `--remove-systemd`, `-R`
  Stops, disables, and removes the FlatSync `systemd` timer and service files.

  **Example:**

  ```sh
  flatsync -R
  ```

* `--id <action>`
  Manage your device’s FlatSync ID. Use with one of the following actions:

  * `create` — Generates a unique identifier for the device (requires `sudo`)
  * `get` — Displays the current device ID

* `--version`, `-v`
  Displays the current FlatSync version.

* `--debug`, `-D`
  Enables verbose debug output. Useful for development or troubleshooting.

* `--help`, `-h`
  Displays FlatSync usage information.

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
