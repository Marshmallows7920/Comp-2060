extends Area2D

var north_room = null

var entrance = null
var par = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_north_position(pos):
	global_position = pos - $North.position



func overlapping() -> Area2D:
	var overlap_room = null
	if not is_node_ready():
		await ready
	translate(Vector2.ZERO)
	await get_tree().physics_frame
	if has_overlapping_areas():
		print("OVERLAP!")
		var areas = get_overlapping_areas()
		for a in areas:
			if a.is_in_group("Room"):
				overlap_room = a
				break
	return overlap_room


func add_rooms(num_left) -> int:
	return num_left
