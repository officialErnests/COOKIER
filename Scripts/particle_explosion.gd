extends Node2D

@onready var player = $"../../square"
var time = 0
func _ready() -> void:
	$GPUParticles2D.emitting = true

func _process(delta: float) -> void:
	time += delta
	if time > 0.5:
		queue_free()
