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
TODO