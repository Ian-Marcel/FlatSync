# FlatSync


Synchronize flatpak applications between devices.

- - -


## RoadMap

- [ ] the remote_flatpaks file usually contains the most up-to-date list of installed apps, but this is not always the case. In the future, this review of the most up-to-date list should be a separate process in another script, using the metric of which list is the newest, with its metadata: last modified date.

- [ ] some applications should be kept on only one device, so a persistent file called "exclusive" stores the name of these applications and during synchronization it scans the "uninstall" and if it finds an application that is in both files, it removes it from the "uninstall" and from the "localflatpaks" file, which after synchronization will be transformed into the new "remoteflatpaks".

- - -

- [License - GNU GPL V3](LICENSE)

- [Code commentaries](docs/comments.md)
