# Zero Percent Juice

## Building
The provided build script builds for MacOS, Windows, and Linux. Built executables are zipped and placed in `./build`.

> [!IMPORTANT]
> Linux builds use [appimagetool](https://github.com/AppImage/appimagetool), which is only available on Linux systems.

Requirements:
- bash
- curl
- sed
```sh
$ ./scripts/build [...darwin|win64|linux|clean]

```

For building a windows binarry on windows run the script `scripts/build.bat` 

## Tools
### Code Formatter
This project uses [StyLua](https://github.com/JohnnyMorganz/StyLua) to keep code format consistent. StyLua can be run with the following command
```sh
$ stylua -g '**/*.lua' .
```

### Testing
Lua unit tests are run with [Busted](https://github.com/lunarmodules/busted).
```sh
$ busted spec
```
