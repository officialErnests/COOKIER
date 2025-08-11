extends Node2D

func _process(_delta: float) -> void:
    global_position = get_viewport().get_camera_2d().global_position