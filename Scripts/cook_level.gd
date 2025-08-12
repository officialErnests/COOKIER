extends Node

var cook_level : int = 0
var cook_multiplier : int = 1
var time_till_end : float = 0
var max_time : float = 5
var tiem_till_collaps : float = 100
signal cook_o_Explosions()

func _process(delta: float) -> void:
	time_till_end -= delta
	tiem_till_collaps -= delta
	if time_till_end <= 0:
		cook_multiplier = 1
