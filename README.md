# Zero Percent Juice

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
