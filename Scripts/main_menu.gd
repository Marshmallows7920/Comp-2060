extends Control

@export_file("*.tscn") var settingsMenu:String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	pass # Replace with function body.


func _on_settings_pressed():
	get_tree().paused = true
	var settings = load(settingsMenu).instantiate()
	add_child(settings)


func _on_quit_pressed():
	get_tree().quit()
