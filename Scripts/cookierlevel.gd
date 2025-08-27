extends Label

enum funn {
	COOKIES,
	MULTIPLIER,
	EXPLOSION,
	SPEED,
	TIME,
	BAKED
}	

@export var display : funn = funn.COOKIES
@onready var player = $"../../.."
func _process(delta: float) -> void:
	if display == funn.COOKIES:
		text = "COOKIER LEVEL: " + str(int(CookLevel.cook_level)) + "00"  
		scale = Vector2.ONE * (CookLevel.cook_level/10000000000.0 + 1)
	elif display == funn.MULTIPLIER:
		var normal_cook_multiplier = max(CookLevel.cook_multiplier/100, 1)
		text = str(int(CookLevel.cook_multiplier)) + "X"
		position = Vector2(10,157.5) + Vector2(randf_range(0,2), randf_range(-1,1)) * (normal_cook_multiplier / 10) * pow((CookLevel.time_till_end / CookLevel.max_time),2)
		# print(Vector2(randf_range(0,2), randf_range(-1,1)) , (normal_cook_multiplier / 10) , pow((CookLevel.time_till_end / CookLevel.max_time),2))
		scale = Vector2.ONE * (normal_cook_multiplier / 1000 + 1)
	elif display == funn.SPEED:
		text = str(int(player.velocity.length())) + " SPEED"
		position = Vector2(546.0,157.5) + Vector2(randf_range(-2,0), randf_range(-1,1)) * (player.velocity.length()/200)
		scale = Vector2.ONE * (player.velocity.length()/10000+1)
	elif display == funn.TIME:

		text = "TIME - " + str(int(CookLevel.tiem_till_collaps)) + " - TIME"
	elif display == funn.BAKED:
		if CookLevel.tiem_till_collaps <= 0:
			visible = true
			if int(CookLevel.tiem_till_collaps/2) % 2 != 0:
				text = "--!!!BAKED!!!--"
				set("theme_override_font_sizes/font_size", 70)
			else:
				text = "COOKIER LEVEL: " + str(CookLevel.cook_level) + "00"
				set("theme_override_font_sizes/font_size", 53 - 2 * str(CookLevel.cook_level).length())
				#52 49 46 43
