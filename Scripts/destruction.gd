extends TileMapLayer

func destory(in_position, radius) -> void:
	var t_position = Vector2i(round(in_position/16))
	print(t_position, in_position)
	var pos2 : Array[Vector2i] = []
	for x in range(radius*2 + 3):
		if get_cell_tile_data(t_position + Vector2i(x - radius - 1,radius + 1)):
			pos2.append(t_position + Vector2i(x - radius - 1,radius + 1))
		if get_cell_tile_data(t_position + Vector2i(x - radius - 1,-radius - 1)):
			pos2.append(t_position + Vector2i(x - radius - 1,-radius - 1))
	for y in range(radius*2 + 3):
		if get_cell_tile_data(t_position + Vector2i(radius + 1, y - radius - 1)):
			pos2.append(t_position + Vector2i(radius + 1, y - radius - 1))
		if get_cell_tile_data(t_position + Vector2i(-radius - 1, y - radius - 1)):
			pos2.append(t_position + Vector2i(-radius - 1, y - radius - 1))
	for x in range(radius*2 + 3):
		for y in range(radius*2 + 3):
			erase_cell(t_position + Vector2i(x - radius - 1, y - radius - 1))
	print(pos2)
	set_cells_terrain_connect(pos2,0,0)
