extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

var trigered = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CookLevel.tiem_till_collaps <= 0 and not trigered:
		trigered = true
		visible = true
		$Rebake.grab_focus()



func _on_eat_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/MainMenu.tscn")

func _on_rebake_button_up() -> void:
	get_tree().change_scene_to_file("res://Scene/main_game.tscn")
