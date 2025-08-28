extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_linear = CookLevel.volume * 0.5
	play(CookLevel.audio_progresion)

func _process(delta: float) -> void:
	volume_linear = CookLevel.volume * 0.5
	CookLevel.audio_progresion = get_playback_position()
	if !playing:
		play()

