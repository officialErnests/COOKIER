extends Camera2D

var NB_velocity = Vector2(0,0)
var NB_global_pos = Vector2(0,0)

func _process(delta: float) -> void:
    NB_velocity += (get_parent().global_position - NB_global_pos) * delta * 10
    NB_global_pos += NB_velocity
    global_position = NB_global_pos
    NB_velocity *= 0.5