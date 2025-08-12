extends TileMapLayer

var particle = preload("res://Scene/particle_explosion.tscn")
func destory(in_position, radius) -> void:
	var t_position = Vector2i(round(in_position/16))
	# print(t_position, in_position)
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
			if get_cell_tile_data(t_position + Vector2i(x - radius - 1, y - radius - 1)):
				erase_cell(t_position + Vector2i(x - radius - 1, y - radius - 1))
				particles((t_position + Vector2i(x - radius - 1, y - radius - 1))*16)
	CookLevel.cook_level += pow(radius * 2,2) * CookLevel.cook_multiplier
	CookLevel.cook_multiplier += pow(radius * 2,2)
	CookLevel.time_till_end = CookLevel.max_time
	CookLevel.cook_o_Explosions.emit(pow(radius * 2,2))
	set_cells_terrain_connect(pos2,0,0)

func particles(in_position) -> void:
	var temp = particle.instantiate()
	add_child(temp)
	temp.global_position = in_position