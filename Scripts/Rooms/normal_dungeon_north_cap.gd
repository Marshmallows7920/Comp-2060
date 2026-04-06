extends Area2D

var south_room = null

var entrance = null
var par = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_south_position(pos):
	global_position = pos - $South.position



func overlapping() -> Area2D:
	var overlap_room = null
	get_tree().physics_frame
	if has_overlapping_areas():
		var areas = get_overlapping_areas()
		for a in areas:
			if a.is_in_group("Room"):
				overlap_room = a
				break
	return overlap_room


func add_rooms(num_left) -> int:
	return num_left
