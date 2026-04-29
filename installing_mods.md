# Installing Mods

Mods are installed by placing `mod_*.lua` mod files in a `mods` folder somewhere in the Lua require path of the game. The exact location of this folder differs from system to system.

**MacOS:** `Zero Percent Juice.app/Contents/Resources/mods` \
**Windows:** `./mods` (relative to executable)

### Linux Instructions
Because the game is packaged as an AppImage, mod installation requires extracting and re-packaging the AppImage. This requires installation of [appimagetool](https://github.com/AppImage/appimagetool). (Note: if you've run the [`build`](/scripts/build) script, `appimagetool` is likely cached in `/tmp`)
```sh
$ ./Zero_Percent_Juice.AppImage --appimage-extract
$ cp -r ./mods ./squashfs-root/bin
$ appimagetool ./squashfs-root Zero_Percent_Juice-Modded.AppImage
$ rm -r ./squashfs-root
```
