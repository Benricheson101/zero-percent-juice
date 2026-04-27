# Modding Documentation
This document is meant to be a guide for modders who want to create mods for Zero Percent Juice. It will cover the basics of how to create a mod, how to load it, and how to use the API.

## Creating a Mod
In Zero Percent Juice, a mod is considered a Lua file in a `mods` folder whose name begins with `mod_`
To create your own mod:
1. Create a `./mods` folder in the root of the project
2. Inside that folder, create a new file named `mod_YourModNAmeHere.lua` with the content `print("Hello, world!")`
3. Run the game with the `--console` argument
4. If the mod was loaded correctly, you should see your `Hello, world!` message printed to the console

## The Modding API
Mods can optionally return a table to give your mod access to various callback functions.
**Mod call back functions**
To use these, simply define them on the table you return:
- `gameLoaded(scenemanager)` - called when the game has finished loading, and passes a reference to the game's scene manager. this can be used to register your own scenes
- `keypressed(key, scancode, isrepeat)` - called when a key is pressed
- `keyreleased(key, scancode)` - called when a key is released
- `mousepressed(x, y, button, istouch, presses)` - called when a mouse button is pressed
- `mousereleased(x, y, button, istouch, presses)` - called when a mouse button is released

## Zero Percent Juice API
Due to the game being made in Lua, most of the game functionality is readily accessible and mutable.

### Example Mod
Rendering something on top of the main menu:
```lua
-- first, acquire a reference to the main menu
local mainMenu = require("scenes.mainmenu")

-- create a backup reference to the main menu's `draw` function
local oldMainMenuDraw = mainMenu.draw
-- make a new implementation of the draw function and call the old method from within it
function mainMenu:draw()
    oldMainMenuDraw(self) -- make sure to pass in self!
    -- your own draw calls here
end
```

All rendering in the game is done through the `love.graphics` library. This does not need to be imported as it is automatically present.

### Available Game Functions:
The game provides various 'classes' and functions to assist in development.
1. `util.ui` Provides Ui scaling utilities, primarily: `scaleCoord` and `scaleDimension`. All dimensions are scaled relative to a base window size of `1280 x 720`, so plan any graphical additions being that size.
2. `util.fonts` Provides several (auto scaled) fonts:
   1. `impact75`
   2. `impact50`
   3. `tahoma30`
   4. `tahoma14`
   5. `tahoma25`
   6. `tahoma40`
3. `util.color` Provides utility functions for converting colors from standard formats to LOVE2D's color format.
4. `renderer.scene` This class is the base for all game scenes. It provides callback functions for most forms of input provided by the LOVE API. Scene switching is accomplished through the use of `self.scene_manager:transition("scene name")` inside of a scene
5. `renderer.scenemanager` This class manages what is currently being rendered. You can add your own scenes to the instance used by the game through the `gameLoaded` mod callback.
6. `upgrade` The base for any in-game upgrades you might want to add. The constructor takes a name, a sprite draw function, and a price calculation function.
7. `upgrades` This file provides a table containing all of the upgrades the game contains. New upgrades can be appended to the returned list.

For anything else you might want to do, the game is open source, so take a look around.
