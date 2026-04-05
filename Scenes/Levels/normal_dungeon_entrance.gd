extends Node2D

@export var num_rooms:int = 5
@export_file("*.tscn") var room1:String
@export_file("*.tscn") var exit:String
@export_file("*.tscn") var north_cap:String
@export_file("*.tscn") var east_cap:String
@export_file("*.tscn") var south_cap:String
@export_file("*.tscn") var west_cap:String

var south_room = null

# Called when the node enters the scene tree for the first time.
func _ready():
	south_room = set_room()
	south_room.north_room = self
	south_room.add_rooms(num_rooms)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_room() -> Node2D:
	var room = load(room1).instantiate()
	add_child(room)
	room.set_north_position($South.global_position)
	return room
	
