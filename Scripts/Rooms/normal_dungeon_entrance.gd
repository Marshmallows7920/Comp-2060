extends Area2D

@export var num_rooms:int = 5
@export_file("*.tscn") var room1:String
@export_file("*.tscn") var room2:String

@export_file("*.tscn") var exit:String
@export_file("*.tscn") var north_cap:String
@export_file("*.tscn") var east_cap:String
@export_file("*.tscn") var south_cap:String
@export_file("*.tscn") var west_cap:String

@onready var north_entrance_rooms = [room1, room2]

var south_room = null

var all_rooms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	south_room = set_room()
	all_rooms.append(south_room)
	south_room.north_room = self
	print("%d out of %d rooms added!" % [num_rooms - await south_room.add_rooms(num_rooms-1), num_rooms])
	add_exit()
	$Player.process_mode = Node.PROCESS_MODE_INHERIT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_room() -> Node2D:
	north_entrance_rooms.shuffle()
	var room = load(north_entrance_rooms[0]).instantiate()
	add_child(room)
	room.set_north_position($South.global_position)
	room.entrance = self
	room.par = self
	return room


func add_rooms(num_left) -> int:
	return num_left


func add_exit():
	var possible_exits = []
	for r in all_rooms:
		print(r.name)
		if r.is_in_group("NorthCap"):
			possible_exits.append(r)
	if possible_exits.size() > 0:
		possible_exits.shuffle()
		var par = possible_exits[0].par
		all_rooms.erase(possible_exits[0])
		possible_exits[0].queue_free()
		var room = load(exit).instantiate()
		par.north_room = room
		par.add_child(room)
		room.south_room = par
		room.set_south_position(par.get_node("North").global_position)
	else:
		print("No possible exits!")
		south_room.queue_free()
		all_rooms = []
		num_rooms += 1
		_ready()
