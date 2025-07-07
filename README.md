# FlatSync


Synchronize flatpak applications between devices.

- - -

## How to install

Copy the follwing command and paste it in your terminal:

```sh
curl -sSL https://from.ianmarcel.dev/install/flatsync | bash
```

## RoadMap

- [ ] Support exclusive applications on a single device
  - A persistent file named `exclusive` stores the names of these applications.
  - During synchronization:
    - The system scans the `uninstall` file.
    - If an application is found in both `exclusive` and `uninstall`, it is:
      - Removed from `uninstall`.
      - Removed from `localflatpaks`, which becomes the new `remoteflatpaks` after syncing.


- - -

- [Code commentaries](docs/comments.md)

- [License - GNU GPL V3](LICENSE)
