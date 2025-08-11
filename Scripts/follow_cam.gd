extends ColorRect

@export var spinn = 0

func _process(delta: float) -> void:
	rotation += spinn * delta
	global_position = (get_viewport().get_camera_2d().global_position - size/2)
