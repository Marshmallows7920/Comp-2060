extends Area2D

@export_file("*.tscn") var room1:String
@export_file("*.tscn") var room2:String

@export_file("*.tscn") var exit:String
@export_file("*.tscn") var north_cap:String
@export_file("*.tscn") var east_cap:String
@export_file("*.tscn") var south_cap:String
@export_file("*.tscn") var west_cap:String

@onready var east_entrance_rooms = [room1, room2]
@onready var south_entrance_rooms = [room1]
@onready var west_entrance_rooms = [room1,room2]

var north_room = null
var east_room = null
var west_room = null

var entrance = null
var par = null

var new_rooms = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	pass



func set_north_position(pos):
	global_position = pos - $North.position

func set_east_position(pos):
	global_position = pos - $East.position

func set_west_position(pos):
	global_position = pos - $West.position



func overlapping() -> Area2D:
	var overlap_room = null
	await get_tree().physics_frame
	if has_overlapping_areas():
		var areas = get_overlapping_areas()
		for a in areas:
			if a.is_in_group("Room"):
				overlap_room = a
				break
	return overlap_room



func add_rooms(num_left) -> int:
	#set_gen_options()
	var left = num_left
	var num_openings = 0
	var open_rooms = []
	if north_room == null:
		num_openings += 1
		open_rooms.append("north")
	if east_room == null:
		num_openings += 1
		open_rooms.append("east")
	if west_room == null:
		num_openings += 1
		open_rooms.append("west")
	var num_add = 0
	if num_left > 0:
		num_add = randi_range(1,min(num_left,num_openings))
	open_rooms.shuffle()
	var num_remaining = num_add
	for i in range(0,num_openings):
		var change = 0
		match open_rooms[i]:
			"north":
				change = await add_north_room(num_remaining)
			"east":
				change = await add_east_room(num_remaining)
			"west":
				change = await add_west_room(num_remaining)
		num_remaining += change
		left += change
	new_rooms.shuffle()
	for r in new_rooms:
		if r != null:
			left = await r.add_rooms(left)
	return left



func add_north_room(num_left) -> int:
	var room = null
	var overlapping_room = null
	var change = 0
	if num_left > 0:
		south_entrance_rooms.shuffle()
		room = load(south_entrance_rooms[0]).instantiate()
		room.set_south_position($North.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = -1
	
	if num_left <= 0 or overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = load(north_cap).instantiate()
		room.set_south_position($North.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = 0
		
	if overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = overlapping_room
	else:
		new_rooms.append(room)
		entrance.all_rooms.append(room)
	
	north_room = room
	north_room.south_room = self
	return change



func add_east_room(num_left) -> int:
	var room = null
	var overlapping_room = null
	var change = 0
	if num_left > 0:
		west_entrance_rooms.shuffle()
		room = load(west_entrance_rooms[0]).instantiate()
		room.set_west_position($East.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = -1
	
	if num_left <= 0 or overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = load(east_cap).instantiate()
		room.set_west_position($East.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = 0
		
	if overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = overlapping_room
	else:
		new_rooms.append(room)
		entrance.all_rooms.append(room)
	
	east_room = room
	east_room.west_room = self
	return change



func add_west_room(num_left) -> int:
	var room = null
	var overlapping_room = null
	var change = 0
	if num_left > 0:
		east_entrance_rooms.shuffle()
		room = load(east_entrance_rooms[0]).instantiate()
		room.set_east_position($West.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = -1
	
	if num_left <= 0 or overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = load(west_cap).instantiate()
		room.set_east_position($West.position)
		room.entrance = entrance
		room.par = self
		add_child(room)
		overlapping_room = await room.overlapping()
		change = 0
		
	if overlapping_room != null:
		if room != null:
			await room.queue_free()
		room = overlapping_room
	else:
		new_rooms.append(room)
		entrance.all_rooms.append(room)
	
	west_room = room
	west_room.east_room = self
	return change



func set_gen_options():
	_ready()
	east_entrance_rooms = [room1, room2]
	south_entrance_rooms = [room1]
	west_entrance_rooms = [room1,room2]
