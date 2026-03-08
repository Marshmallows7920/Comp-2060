extends TileMap



func _use_tile_data_runtime_update(_layer, coords):
	if coords in get_used_cells(1): #id 1 = obstacles layer
		print(_layer, " ", coords, " true")
		return true #if obstacle at coords it will update tile (to remove nav)
	else:
		print(_layer, " ", coords, " false")
		return false



func _tile_data_runtime_update(_layer, _coords, tile_data):
	tile_data.set_navigation_polygon(0, null) #removes navigation from tile
