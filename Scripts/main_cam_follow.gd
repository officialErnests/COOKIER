extends Camera2D

var NB_velocity = Vector2(0,0)
var NB_global_pos = Vector2(0,0)
var NB_zoomVel = 1
var time_from_pause : float = 0

func _ready() -> void:
	CookLevel.tiem_till_collaps = CookLevel.max_time_collapse
	zoom = Vector2.ONE * (15.0/CookLevel.map_size.x)

func _process(delta: float) -> void:
	if CookLevel.loading:
		zoom = Vector2.ONE * (15.0/CookLevel.map_size.x)
		return
	zoom += (Vector2.ONE * NB_zoomVel)
	zoom = clamp(zoom.x, 0.125, 10) * Vector2.ONE
	global_position = NB_global_pos
	NB_velocity *= 0.5
	NB_zoomVel *= 0.5
	NB_velocity += (get_parent().global_position - NB_global_pos) * delta * 5
	NB_zoomVel += (1 - zoom.x) * delta
	NB_global_pos += NB_velocity
	if CookLevel.tiem_till_collaps < 0:
		NB_velocity += (get_parent().global_position - NB_global_pos) * min(abs(CookLevel.tiem_till_collaps), 1)
		NB_zoomVel += (1 - zoom.x) * min(abs(CookLevel.tiem_till_collaps),1)
