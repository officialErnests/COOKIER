extends CharacterBody2D

var SPEED = 200
var prev_velocity = 0
var charge = false
@export var ground : TileMapLayer

func _physics_process(delta: float) -> void:
	velocity.x += Input.get_axis("left","right") * delta * SPEED
	velocity.y += delta * 100
	rotation_degrees += velocity.length() * delta * 10 * (1 if velocity.x > 0 else -1)
	charge = false
	if is_on_floor() :
		if Input.is_action_pressed("jump"):
			velocity.y += -100
		if Input.is_action_pressed("down"):
			velocity.x += 1000 * delta if velocity.x > 0 else -1000 * delta
			velocity *= 0.98
			$MainCam.position = velocity/20 * Vector2(randi_range(-1,1),randi_range(-1,1))
			charge = true
	else:
		if Input.is_action_pressed("down"):
			velocity.y = 1000
	if is_on_wall():
		ground.destory(position,2)
		velocity.y -= abs(prev_velocity.x)
	# angular_velocity += Input.get_axis("left","right") * delta * SPEED / 10
	velocity *= 0.99
	prev_velocity = velocity
	if not charge:
		$MainCam.position = Vector2(0,0)
		move_and_slide()
