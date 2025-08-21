extends Control

@export var logo : Control
@export var text : Control
var timer = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta * 1
	if timer < 0:
		position += Vector2(randf_range(-50,50),randf_range(-50,50)) * -timer * -timer
	if randf() * 1000 < timer + 1:
		timer = -1
		position += Vector2(randf_range(-10,10),randf_range(-10,10))
		logo.visible = !logo.visible
		text.visible = !text.visible
