extends CharacterBody2D

var SPEED = 400
var prev_velocity = 0
var charge = false
var update = 0
@export var ground : TileMapLayer
@onready var camera = $MainCam

func _ready() -> void:
	$Charge.volume_linear = CookLevel.volume

func _physics_process(delta: float) -> void:
	if CookLevel.loading: return
	var tTime_dialation =  CookLevel.time_dialation
	velocity.y += delta * 500 * (1-tTime_dialation)
	charge = false
	if is_on_ceiling():
		if prev_velocity.y < -200:
			ground.destory(position,2)
		velocity.y = prev_velocity.y  * 0.9
		if Input.is_action_pressed("jump"):
			velocity.y -= 100
		if Input.get_axis("left","right") == getDirection(prev_velocity.x) * -1:
			velocity.x = -prev_velocity.x 
			camera.NB_global_pos.x = global_position.x
	if is_on_floor():
		velocity *= 0.99
		velocity.x += Input.get_axis("left","right") * delta * SPEED
		var ground_destruction = false
		if prev_velocity.y > 500:
			camera.global_position = global_position
			if Input.is_action_pressed("down"):
				ground_destruction = true
				velocity.y = prev_velocity.y
				ground.destory(position + Vector2(0,-16),floor(prev_velocity.y/2000))
				velocity.x += prev_velocity.y / 10 if velocity.x > 0 else -prev_velocity.y / 10
			else:
				velocity.x += prev_velocity.y if velocity.x > 0 else -prev_velocity.y
				ground.destory(position + Vector2(0,-16),floor(prev_velocity.y/200))
				camera.NB_zoomVel -= 1/camera.zoom.x * 2
				camera.zoom = Vector2.ONE * 5
		if Input.is_action_pressed("jump"):
			if ground_destruction and abs(velocity.y) > 300:
				velocity.y = -velocity.y
			else:
				velocity.y = -300
		if Input.is_action_pressed("down") and not ground_destruction:
			if $Charge.playing:
				$Charge.pitch_scale = velocity.length() / 100
			else:
				$Charge.play()
			velocity.x += (1000 * delta if velocity.x > 0 else -1000 * delta)
			velocity *= 0.98
			camera.NB_velocity += velocity/100 * Vector2(randi_range(-1,1),randi_range(-1,1))
			charge = true
	else:
		velocity *= 1 - 0.005 * (1-tTime_dialation)
		velocity.x += Input.get_axis("left","right") * delta * SPEED / 2
		if Input.is_action_pressed("down"):
			velocity.y += 100
	if is_on_wall():
		if abs(prev_velocity.x) > 300:
			ground.destory(position + Vector2(0,-16*1.5),abs(prev_velocity.x)/300)
			# print(int(Input.get_axis("left","right")), getDirection(prev_velocity.x))
			if Input.get_axis("left","right") == getDirection(prev_velocity.x) * -1:
				velocity.x = -prev_velocity.x 
				camera.NB_global_pos.x = global_position.x
			else:
				velocity.x = prev_velocity.x * 0.95
				camera.NB_velocity += velocity / 100
			# position.x -= velocity.x / 100
		if Input.is_action_pressed("jump"):
			velocity.y -= 100
	# angular_velocity += Input.get_axis("left","right") * delta * SPEED / 10
	prev_velocity = velocity
	camera.NB_zoomVel -= velocity.length() / 200000
	rotation_degrees += velocity.length() * delta * 10 * (1 if velocity.x > 0 else -1)
	if not charge:
		if $Charge.playing:
			$Charge.stop()
		camera.position = Vector2(0,0)
		if update <= 0:
			update = tTime_dialation / 3.0
			move_and_slide()
		else:
			update -= delta
	if CookLevel.tiem_till_collaps > 0 and (abs(position.x) / 16 > CookLevel.map_size.x + CookLevel.border_size or position.y / 16 > CookLevel.map_size.y + CookLevel.border_size):
		CookLevel.tiem_till_collaps = 0

func getDirection(i_position) -> int:
	return 1 if i_position > 0 else 0 if i_position == 0 else -1
