extends Control

@export_file("*.tscn") var settingsMenu:String
@export_file("*.tscn") var mainMenu:String



var tabContainer


# video variables
var windowMode
var windowWidth
var windowHeight
var maxWindowWidth
var maxWindowHeight
# video UI
var windowModeOptionButton
var windowSizeHBox
var windowSizeOptionButton


# audio variables
var masterVolume
# audio UI
var masterVolumeSlider
var masterVolumeSpin



func _ready():
	setUINodeVariables()
	tabContainer.current_tab = 0
	videoTabSetup()
	audioTabSetup()


func _process(delta):
	pass



# ========== SIGNAL FUNCTIONS ==========

func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file(mainMenu)
	get_tree().paused = false


func _on_window_mode_option_item_selected(index):
	match index:
		0:
			windowMode = DisplayServer.WINDOW_MODE_WINDOWED
			windowSizeHBox.visible = true
		1:
			windowMode = DisplayServer.WINDOW_MODE_FULLSCREEN
			windowSizeHBox.visible = false
			windowSizeSelectCurrent()
		2:
			windowMode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
			windowSizeHBox.visible = false
			windowSizeSelectCurrent()


func _on_window_size_option_item_selected(index):
	match index:
		0:
			windowWidth = 3840
			windowHeight = 2160
		1:
			windowWidth = 2560
			windowHeight = 1440
		2:
			windowWidth = 1920
			windowHeight = 1080
		3:
			windowWidth = 1280
			windowHeight = 720
		4:
			windowWidth = 854
			windowHeight = 480
		5:
			windowWidth = 640
			windowHeight = 360


func _on_master_volume_slider_value_changed(value):
	masterVolume = value
	masterVolumeSpin.value = value


func _on_master_volume_spin_value_changed(value):
	masterVolume = value
	masterVolumeSlider.value = value


func _on_confirm_pressed():
	# video
	if windowMode != null:
		DisplayServer.window_set_mode(windowMode)
	if windowSizeOptionButton.selected != -1:
		get_window().size.x = windowWidth
		get_window().size.y = windowHeight
	# audio
	# to do - update global volume values


func _on_cancel_pressed():
	windowMode = null
	_ready()


func _on_back_pressed():
	get_tree().paused = false
	queue_free()



# ========== FUNCTIONS ==========

func setUINodeVariables():
	tabContainer = $MarginContainer/VBoxContainer/TabContainer
	
	windowModeOptionButton = $MarginContainer/VBoxContainer/TabContainer/Video/MarginContainer/VBoxContainer/WindowModeHBox/WindowModeOption
	windowSizeHBox = $MarginContainer/VBoxContainer/TabContainer/Video/MarginContainer/VBoxContainer/WindowSizeHBox
	windowSizeOptionButton = $MarginContainer/VBoxContainer/TabContainer/Video/MarginContainer/VBoxContainer/WindowSizeHBox/WindowSizeOption
	
	masterVolumeSlider = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MasterVolumeSlider
	masterVolumeSpin = $MarginContainer/VBoxContainer/TabContainer/Audio/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MasterVolumeSpin


func videoTabSetup():
	var currentMode = DisplayServer.window_get_mode()
	if currentMode == DisplayServer.WINDOW_MODE_WINDOWED:
		windowModeOptionButton.selected = 0
		windowSizeHBox.visible = true
	elif currentMode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		windowModeOptionButton.selected = 1
		windowSizeHBox.visible = false
	elif currentMode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		windowModeOptionButton.selected = 2
		windowSizeHBox.visible = false
	else:
		windowSizeHBox.visible = true
	
	maxWindowWidth = DisplayServer.screen_get_size().x
	maxWindowHeight = DisplayServer.screen_get_size().y
	if maxWindowHeight < 2160:
		windowSizeOptionButton.set_item_disabled(0, true)
	if maxWindowHeight < 1440:
		windowSizeOptionButton.set_item_disabled(1, true)
	if maxWindowHeight < 1080:
		windowSizeOptionButton.set_item_disabled(2, true)
	if maxWindowHeight < 720:
		windowSizeOptionButton.set_item_disabled(3, true)
	if maxWindowHeight < 480:
		windowSizeOptionButton.set_item_disabled(4, true)
	
	windowSizeSelectCurrent()


func windowSizeSelectCurrent():
	windowWidth = get_window().size.x
	windowHeight = get_window().size.y
	if windowWidth == 3840 and windowHeight == 2160:
		windowSizeOptionButton.selected = 0
	elif windowWidth == 2560 and windowHeight == 1440:
		windowSizeOptionButton.selected = 1
	elif windowWidth == 1920 and windowHeight == 1080:
		windowSizeOptionButton.selected = 2
	elif windowWidth == 1280 and windowHeight == 720:
		windowSizeOptionButton.selected = 3
	elif windowWidth == 854 and windowHeight == 480:
		windowSizeOptionButton.selected = 4
	elif windowWidth == 640 and windowHeight == 360:
		windowSizeOptionButton.selected = 5
	else:
		windowSizeOptionButton.selected = -1


func audioTabSetup():
	# to do - get master volume from global value
	pass









