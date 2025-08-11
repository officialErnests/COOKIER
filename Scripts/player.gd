extends CharacterBody2D

var SPEED = 200
var prev_velocity = 0
var charge = false
@export var ground : TileMapLayer
@onready var camera = $MainCam

func _physics_process(delta: float) -> void:
	velocity.y += delta * 500
	rotation_degrees += velocity.length() * delta * 10 * (1 if velocity.x > 0 else -1)
	charge = false
	if is_on_ceiling():
		if prev_velocity.y < -200:
			ground.destory(position,1)
		velocity.y = prev_velocity.y / 2 - 100
		if Input.is_action_pressed("jump"):
			velocity.y -= 100
	if is_on_floor():
		velocity *= 0.99
		velocity.x += Input.get_axis("left","right") * delta * SPEED
		if prev_velocity.y > 200:
			ground.destory(position + Vector2(0,-16),1)
		if Input.is_action_pressed("jump"):
			velocity.y = -300
		if Input.is_action_pressed("down"):
			velocity.x += 1000 * delta if velocity.x > 0 else -1000 * delta
			velocity *= 0.98
			camera.position = velocity/20 * Vector2(randi_range(-1,1),randi_range(-1,1))
			charge = true
	else:
		velocity *= 0.995
		velocity.x += Input.get_axis("left","right") * delta * SPEED / 2
		if Input.is_action_pressed("down"):
			velocity.y += 50
	if is_on_wall():
		if abs(prev_velocity.x) > 300:
			ground.destory(position + Vector2(0,-16*1.5),1)
			print(int(Input.get_axis("left","right")), getDirection(prev_velocity.x))
			if Input.get_axis("left","right") == getDirection(prev_velocity.x) * -1:
				velocity.x = -prev_velocity.x 
			else:
				velocity.x = prev_velocity.x 
			# position.x -= velocity.x / 100
		if Input.is_action_pressed("jump"):
			velocity.y -= 10
	# angular_velocity += Input.get_axis("left","right") * delta * SPEED / 10
	prev_velocity = velocity
	if not charge:
		camera.position = Vector2(0,0)
		move_and_slide()

func getDirection(i_position) -> int:
	return 1 if i_position > 0 else 0 if i_position == 0 else -1
