extends Camera2D

var NB_velocity = Vector2(0,0)
var NB_global_pos = Vector2(0,0)
var NB_zoomVel = 1

func _process(delta: float) -> void:
	zoom += (Vector2.ONE * NB_zoomVel)
	zoom = clamp(zoom.x, 0.125, 10) * Vector2.ONE
	global_position = NB_global_pos
	NB_velocity *= 0.5
	NB_zoomVel *= 0.5
	NB_velocity += (get_parent().global_position - NB_global_pos) * delta * 10
	NB_zoomVel += (1 - zoom.x) * delta
	NB_global_pos += NB_velocity
