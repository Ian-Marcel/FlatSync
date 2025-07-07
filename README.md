# FlatSync


Synchronize flatpak applications between devices.

- - -

## How to install

Simply copy the following command and paste it in your terminal:

```sh
curl -sSL https://from.ianmarcel.dev/install/flatsync | bash
```

## RoadMap

- [ ] Support exclusive applications on a single device
  - A persistent file named `exclusive` stores the names of these applications.
  - How it goes:
    - During synchronization the system scans the `uninstall` file.
    - If an application is found in both `exclusive` and `uninstall`, it is:
      - Removed from `uninstall`.
      - Removed from `local_flatpaks`, which becomes the new `remote_flatpaks` after syncing.


- - -

- [Code commentaries](docs/comments.md)

- [License - GNU GPL V3](LICENSE)
