extends TileMapLayer

@export var map_size = Vector2i(300,100)
@export var islands = 0
@export var ground_deviation = 100
@export var ground_deviation_range = 10
@export var ground_depth = 30
@export var border_size = 30
@export var normiles_terain = 100
@export var ground_spike_min_distance = 10
@export var ground_spike_chance = 5
@export var ground_spike_width = 4
@export var ground_spike_lenght = 100
@export var ground_spike_rand_width = 10
@export var ground_spike_rand_lenght = 10
@export var visual = true

func _init() -> void:
	CookLevel.loading = true
	CookLevel.map_size = map_size

func get_random(start, end) -> float:
	var result = 0
	for i in normiles_terain:
		result += randf_range(start, end) * 1/normiles_terain
	return result

func gen_main_terrain(start, end, step):
	var curent_ground = 0
	var next_ground = 0
	var dir_mul = 1 if step > 0 else -1
	var temp_grnd = []
	for ground_x in range(start,end,step):
		next_ground = clamp(curent_ground + get_random(-ground_deviation, ground_deviation), map_size.y*-1, map_size.y-1)
		for ground_transition_x in range(0,ground_deviation_range  * dir_mul, step):
			var normalized = abs(float(ground_transition_x) / ground_deviation_range)
			var temp_y = clamp(floor(curent_ground * (1 - normalized) + next_ground * normalized), map_size.y*-1, map_size.y - 1)
			if ground_depth + temp_y < map_size.y - ground_spike_min_distance and randf_range(0, 100) < ground_spike_chance:
				var max_depth = ground_depth
				var lenght = ground_spike_lenght + randf_range(0, ground_spike_rand_lenght)
				var sizwidth = ground_spike_width + randf_range(0, ground_spike_rand_width)
				while temp_y < map_size.y:
					temp_y += 1
					max_depth -= 1
					if max_depth > 0:
						temp_grnd.append(Vector2i(ground_x * ground_deviation_range + ground_transition_x, temp_y))
					else:
						#pov u spend 30 mins in desmos messing around XD
						# var temp = 1/(sin(max_depth * 0.3 - 0.44) * 0.83 + 0.9)
						# var temp2 = temp * sin(max_depth*0.3+3.8) * 1.2 + 1.5
						# var temp2 = ceil(pow((float(-max_depth % temp) / temp), 4) * 10)
						var temp2 = ceil(sin(pow(fmod(-max_depth/(lenght * 0.75), 1.33), 4)) * sizwidth)
						for xadd in range(-temp2, temp2):
							temp_grnd.append(Vector2i(ground_x * ground_deviation_range + ground_transition_x + xadd, temp_y))
			else:
				var max_depth = ground_depth
				while temp_y < map_size.y and max_depth != 0:
					temp_y += 1
					max_depth -= 1
					temp_grnd.append(Vector2i(ground_x * ground_deviation_range + ground_transition_x, temp_y))
		if temp_grnd.size() > 1000 and visual:
			set_cells_terrain_connect(temp_grnd,0,0)
			await get_tree().create_timer(0.1).timeout
		curent_ground = next_ground
	set_cells_terrain_connect(temp_grnd,0,0)


func _ready() -> void:
	await get_tree().create_timer(1).timeout
	gen_main_terrain(0,map_size.x/ground_deviation_range, 1)
	gen_main_terrain(0,-(map_size.x/ground_deviation_range), -1)
	var temp_grnd = []
	for ground_y in range(-map_size.y,map_size.y):
		for ground_x in range(border_size):
			temp_grnd.append(Vector2i(ground_x + map_size.x, ground_y))
			temp_grnd.append(Vector2i(-ground_x - map_size.x, ground_y))
		if temp_grnd.size() > 1000 and visual:
			set_cells_terrain_connect(temp_grnd,0,0)
			temp_grnd = []
			await get_tree().create_timer(0.1).timeout
	for ground_x in range(-map_size.x - border_size, map_size.x + border_size):
		for ground_y in range(border_size):
			temp_grnd.append(Vector2i(ground_x, map_size.y + ground_y))
		if temp_grnd.size() > 1000 and visual:
			set_cells_terrain_connect(temp_grnd,0,0)
			temp_grnd = []
			await get_tree().create_timer(0.1).timeout	
	set_cells_terrain_connect(temp_grnd,0,0)
	temp_grnd = []

	
	CookLevel.loading = false

var particle = preload("res://Scene/particle_explosion.tscn")
func destory(in_position, radius : int) -> void:
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
				if CookLevel.particles: particles((t_position + Vector2i(x - radius - 1, y - radius - 1))*16)
	if CookLevel.tiem_till_collaps > 0:
		CookLevel.cook_level += pow(radius * 2,2) * CookLevel.cook_multiplier
		CookLevel.cook_multiplier += pow(radius * 2,2)
	CookLevel.time_till_end = CookLevel.max_time
	CookLevel.cook_o_Explosions.emit(pow(radius * 2,2))
	set_cells_terrain_connect(pos2,0,0)

func particles(in_position) -> void:
	var temp = particle.instantiate()
	add_child(temp)
	temp.global_position = in_position
