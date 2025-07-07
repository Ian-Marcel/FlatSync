# FlatSync


Synchronize flatpak applications between devices.

- - -

## How to install

Simply copy the following command and paste it in your terminal:

```sh
curl -sSL https://from.ianmarcel.dev/install/flatsync | bash
```

## RoadMap

- [ ] Addition of a `--auto` flag
  - By default, if an aplication is set to be (un)installed, `flatsync` will list the list of applications to be operated and prompt the user to confirm the operation. With `--auto`, `flatsync` will no longer prompt the user for confirmation, (un)installing apps automatically, which is very useful for scheduled syncs.

- [ ] Support for exclusive applications on a single device
  - A persistent file named `exclusive` stores the names of these applications.
  - How it goes:
    1. During synchronization the system scans the `uninstall` file (if exists).
    2. If an application is found in both `exclusive` and `uninstall`, it is:
      	1. Removed from `uninstall`.
    3. It also be removed from the new `remote_flatpaks` after syncing.


- - -

- [Code commentaries](docs/comments.md)

- [License - GNU GPL V3](LICENSE)
