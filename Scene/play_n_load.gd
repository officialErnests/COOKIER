extends VBoxContainer


func _on_play_button_up() -> void:
	CookLevel.map_size = Vector2i($Width/SpinBox.value, $Height/SpinBox.value)
	CookLevel.border_size = $Borders/SpinBox.value
	CookLevel.terain_deviation = $Diviation/SpinBox.value
	CookLevel.terrain_transition = $Transition/SpinBox.value
	CookLevel.spike_chance = $SpikeChance/SpinBox.value
	CookLevel.fastload = $Fastload.button_pressed
	get_tree().change_scene_to_file("res://Scene/main_game.tscn")
