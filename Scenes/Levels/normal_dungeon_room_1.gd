extends Node2D

var north_room = null
var east_room = null
var south_room = null
var west_room = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_north_position(pos):
	global_position = pos + global_position - $North.global_position

func set_east_position(pos):
	global_position = pos + global_position - $East.global_position

func set_south_position(pos):
	global_position = pos + global_position - $South.global_position

func set_west_position(pos):
	global_position = pos + global_position - $West.global_position


func add_rooms(num_left):
	pass
