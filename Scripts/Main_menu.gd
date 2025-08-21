extends TextureRect

func _ready() -> void:
    if find_child("Play"):
        $Play.grab_focus()

func _on_button_2_button_up() -> void:
    CookLevel.particles = !CookLevel.particles
    if CookLevel.particles:
        $Button2.text = "V-PARTICLES"
    else:
        $Button2.text = "X-PARTICLES"

func _on_play_button_up() -> void:
    get_tree().change_scene_to_file("res://Scene/main_game.tscn")


func _on_audio_value_changed(value:float) -> void:
    CookLevel.volume = value
