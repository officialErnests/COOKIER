extends Label

func _process(delta: float) -> void:
    text = "COOKIER LEVEL: " + str(int(CookLevel.cook_level)) + "00"