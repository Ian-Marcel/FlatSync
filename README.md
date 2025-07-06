# FlatSync


Synchronize flatpak applications between devices.

- - -


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
