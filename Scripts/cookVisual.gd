extends ColorRect

@onready var player = $"../../.."

func _process(delta: float) -> void:
	if CookLevel.tiem_till_collaps <= 0 and not int(CookLevel.tiem_till_collaps / 3) % 2 != 0:
		modulate = Color(1.0,1.0,1.0,clamp(pow(player.position.length() / CookLevel.distance_in_oven,2),0,1)/2.0)
	else:
		modulate = Color(1.0,1.0,1.0,0.0)

