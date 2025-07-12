
if [ -d "$HOME"/.local/share/flatpak/overrides ] && [ -d "$FLATSYNC_GIT"/overrides ]; then
	rm -rf "$HOME"/.local/share/flatpak/overrides
	cp -aT "$FLATSYNC_GIT"/overrides "$HOME"/.local/share/flatpak/overrides
elif [ -d "$FLATSYNC_GIT"/overrides ] && ! [ -d "$HOME"/.local/share/flatpak/overrides ]; then
	cp -aT "$FLATSYNC_GIT"/overrides "$HOME"/.local/share/flatpak/overrides
fi
