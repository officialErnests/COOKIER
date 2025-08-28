extends TileMapLayer

var map_size = CookLevel.map_size
@export var islands = 0
var ground_deviation = CookLevel.terain_deviation
var ground_deviation_range = CookLevel.terrain_transition
@export var ground_depth = 30
var border_size = CookLevel.border_size
@export var normiles_terain = 100
@export var ground_spike_min_distance = 10
var ground_spike_chance = CookLevel.spike_chance
@export var ground_spike_width = 4
@export var ground_spike_lenght = 70
@export var ground_spike_rand_width = 10
@export var ground_spike_rand_lenght = 20
var visual = !CookLevel.fastload

var randomSfx = []

func _init() -> void:
	CookLevel.loading = true
	CookLevel.map_size = map_size
	CookLevel.cook_level = 0
	CookLevel.cook_multiplier = 1
	CookLevel.time_till_end = 0
	CookLevel.tiem_till_collaps = CookLevel.max_time_collapse
	CookLevel.time_dialation = 1

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
		if temp_grnd.size() > 2000 and visual:
			set_cells_terrain_connect(temp_grnd,0,0)
			randomSfxPlay()
			await get_tree().create_timer(0.01).timeout
		curent_ground = next_ground
	set_cells_terrain_connect(temp_grnd,0,0)


func _ready() -> void:
	$Crack1.volume_linear = CookLevel.volume
	$Crack2.volume_linear = CookLevel.volume
	$Crack3.volume_linear = CookLevel.volume
	$Eat.volume_linear = CookLevel.volume
	randomSfx.append($Crack1)
	randomSfx.append($Crack2)
	randomSfx.append($Crack3)
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
			randomSfxPlay()
			await get_tree().create_timer(0.01).timeout
	for ground_x in range(-map_size.x - border_size, map_size.x + border_size):
		for ground_y in range(border_size):
			temp_grnd.append(Vector2i(ground_x, map_size.y + ground_y))
		if temp_grnd.size() > 1000 and visual:
			set_cells_terrain_connect(temp_grnd,0,0)
			temp_grnd = []
			randomSfxPlay()
			await get_tree().create_timer(0.01).timeout	
	set_cells_terrain_connect(temp_grnd,0,0)
	temp_grnd = []

	
	CookLevel.loading = false

func randomSfxPlay() -> void:
	var rndSfx : AudioStreamPlayer = randomSfx.pick_random()
	rndSfx.pitch_scale = randf_range(0.9,1.1)
	rndSfx.play()

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
		randomSfxPlay()
	if CookLevel.tiem_till_collaps > 0:
		CookLevel.cook_level += pow(radius * 2,2) * CookLevel.cook_multiplier
		CookLevel.cook_multiplier += pow(radius * 2,2)
		$Eat.pitch_scale = randf_range(0.9,1.1)
		$Eat.play()
	CookLevel.time_till_end = CookLevel.max_time
	CookLevel.cook_o_Explosions.emit(pow(radius * 2,2))
	set_cells_terrain_connect(pos2,0,0)

func particles(in_position) -> void:
	var temp = particle.instantiate()
	add_child(temp)
	temp.global_position = in_position
