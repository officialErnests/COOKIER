extends Node

var cook_level : int = 0
var cook_multiplier : int = 1
var time_till_end : float = 0
var max_time : float = 5
var tiem_till_collaps : float = 10
var max_time_collapse = 100
signal cook_o_Explosions()
var time_dialation = 1
var loading = true

var particles = true
var volume = 1
var map_size = Vector2i(300,100)
var border_size = 30
var terain_deviation = 100
var terrain_transition = 10
var spike_chance = 3

var fastload = false

func _process(delta: float) -> void:
	if loading: return
	time_till_end -= delta
	tiem_till_collaps -= delta
	if time_till_end <= 0:
		cook_multiplier = 0
	time_dialation = clamp((-tiem_till_collaps) / 10, 0, 1)
