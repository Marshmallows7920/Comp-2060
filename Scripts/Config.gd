extends Node

const CONFIG_PATH = "res://config.cfg"

var config = ConfigFile.new()


func _ready():
	if !FileAccess.file_exists(CONFIG_PATH):
		saveConfig()
	else:
		loadConfig()



func saveConfig():
	var windowMode = DisplayServer.window_get_mode()
	config.set_value("video", "window_mode", windowMode)
	if windowMode != DisplayServer.WINDOW_MODE_FULLSCREEN and windowMode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		config.set_value("video", "window_size", get_window().size)
	else:
		config.set_value("video", "window_size", DisplayServer.screen_get_size() * 0.75)
	
	config.set_value("audio", "master_volume", Game.masterVolume)
	
	config.save(CONFIG_PATH)



func loadConfig():
	config.load(CONFIG_PATH)
	
	# get settings from config file
	var videoSettings = {}
	for x in config.get_section_keys("video"):
		videoSettings[x] = config.get_value("video", x)
	
	var audioSettings = {}
	for x in config.get_section_keys("audio"):
		audioSettings[x] = config.get_value("audio", x)
	
	# set settings to config values
	if videoSettings.has("window_mode"):
		var windowMode = videoSettings.window_mode
		DisplayServer.window_set_mode(videoSettings.window_mode)
		if videoSettings.has("window_size"):
			if windowMode != DisplayServer.WINDOW_MODE_FULLSCREEN and windowMode != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				get_window().size = videoSettings.window_size
		else:
			fixConfig()
	else:
		fixConfig()
	
	if audioSettings.has("master_volume"):
		Game.masterVolume = audioSettings.master_volume
	else:
		fixConfig()



func fixConfig():
	if FileAccess.file_exists(CONFIG_PATH):
		DirAccess.remove_absolute(CONFIG_PATH)
	saveConfig()
