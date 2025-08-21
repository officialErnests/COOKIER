extends ColorRect

@onready var player = $"../../.."

func _process(delta: float) -> void:
	modulate = Color(1.0,1.0,1.0,clamp(pow(player.position.length() / CookLevel.distance_in_oven,2),0,1)/2.0)
