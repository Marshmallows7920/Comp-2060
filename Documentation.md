# Documentation

## Scripts (only)

### **Game.gd**

For accessing/storing global variables and functions. Set to autoload when game is launched and should stay open when scene changes happen, so it's always accessible.


### **Config.gd**

For saving and loading settings between closing and launching the game. Used by settings menu for video settings, audio settings, etc. to save settings to config.cfg file when changes made. Autoloads when game is launched and will automatically load last used settings from config.cfg file.

Can delete config.cfg file to restore default launch settings if there's a problem.


## Scenes

### **main_menu.tscn**

Main menu / title screen for the game. First scene when game is launched.


### **settings_menu.tscn**

Settings menu, for changing various game settings. Can be called from anywhere.

To call:
~~~gdscript
get_tree().paused = true # pauses game
var settings = load("res://Scenes/Levels/settings_menu.tscn").instantiate() # loads scene
add_child(settings) # shows scene
~~~












