# Modding Documentaion
This document is meant to be a guide for modders who want to create mods for Zero Percent Juice. It will cover the basics of how to create a mod, how to load it, and how to use the API.

## creating a mod
In Zero Pecrcent Juice a mod is consoterd a lua file in `mods` folder whos name begeins with `mod_`  
To create your own mod follow theese steps:
1. In the same folder as your ZPJ execuable file create a folder named 'mods'
2. Inside that folder create a new file named `mod_YourModNAmeHere.lua`
3. Open the file your juse created in your favorite text editor. 
4. Inside you file wright the following `print("hello world")`
5. open a terminal / command prompt window and run the game with the folowing argurmant `--console`
6. In your terminal you should see logs indicating that your mod was loaded and the message we had it print

## The modding API
In Zero Pecrcent Juice mods can optinally return a table. While returning nothing will not reducde your mods ability to access the game. Returning a table give your mod access to various call back function.  
**Mod call back functions**  
To use theese simply define them on the table you return
- gameLoaded(scenemanager) - runs when the game has finfihed loading and passes a refrnce to the game's scence mangfer allowing you to register your own scenes
- keypressed(key, scancode, isrepeat) - runs when a key press is detected passing in the key that was pressed
- keyreleased(key, scancode) - runs when a key release is detceted passing in the key that was released
- mousepressed(x, y, button, istouch, presses) - runs when a mouse button is pressed passing the location of the mouse and button infomration
- mousereleased(x, y, button, istouch, presses) - runs when a mouse button is released passing the location of the mouse and button information

## Zero Precent Juice API
Due to the game being made in lua, most of the game functinality is easily accesasble and modifiable.   
For example, if you wanted to redner something on top of the main menu, this could be acompished through the following method:
```lua
-- first acuire a refnrec to the main menu
local mainMenu = require("scenes.mainmenu")

--then create a bakcup recfrence to the draw funciton
local oldMainMenuDraw = mainMenu.draw
--make a new implmentation of the draw funcion
function mainMenu:draw()
oldMainMenuDraw(self) -- make sure to pass in self!
--your own draw calls here
end
```

All rendering in the game is done through the `love.graphics` libarary. This does not need to be imported as it is automaialy present. 

### Availbale gam funcility:
The game provides various 'classes' and funcions to assist in developemnt.
1. `util.ui` Provides Ui scaling utilities primarily: `scaleCoord` and `scaleDimension`. All scaled dimentions are relivie to a base window size of 1280x720 so plan any graphical additons being that size.
2. `util.fonts` Provides sevaral diffrent autpmaticaly scled fonts, theyare:
   1. impact75
   2. impact50
   3. tahoma30
   4. tahoma14
   5. tahoma25
   6. tahoma40 
3. `util.color` Provides utility funcions for making colors in more standard formats. The way the underlying color import wors is it want numbser between 0 and 1 
4. `renderer.scene` This class is the base for all screenes that are shown in the game. It provides callabcks for most forms of input providee by the API. Scene switching is acompilshed through the use of `self.scene_manager:transition("scene name")` inside of a scene
5. `renderer.scenemanager` This class handles the management of what is currenly being shown. you can add your own scenes to the instance used by the game through the game loaded mod call back.
6. `upgrade` The base for any upgrade you might want to add. The consttor takes a name, a sprite draw funcion, and a price calcuation funcion.
7. `upgrades` (notice the s at the end) This file provides a table containing all the upgrades the came contains. To add your own upgrades, add new elemmtns to this table.