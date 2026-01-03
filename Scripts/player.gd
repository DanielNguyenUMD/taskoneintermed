extends CharacterBody3D

var cursorVisible = false
var mouseCounter = 0
var playerHp = 100
var maxHp = 100
@onready var healthBar = %ProgressBar

#ONLY EDIT FOR CAMERA DIRECTION AND MOUSE CURSOR

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)
	elif event.is_action_pressed("ui_cancel") and cursorVisible == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		cursorVisible = true
		mouseCounter += 1
		#print(mouseCounter)
	elif event.is_action_pressed("ui_cancel") and cursorVisible == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		cursorVisible = false
		mouseCounter += 1
		#print(mouseCounter)
		
func _physics_process(delta):
	
	#ONLY EDIT BELOW FOR BASIC PLAYER MOVEMENT
		
	var spd = 7
	
	var input_dir_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	)
	
	var input_dir_3D = Vector3(
		input_dir_2D.x, 0.0, input_dir_2D.y
	)
	
	var direction = transform.basis * input_dir_3D
	
	velocity.x = direction.x * spd
	velocity.z = direction.z * spd
	
	#ONLY EDIT BELOW FOR JUMP/FALL
	
	velocity.y -= 9.8 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += 5.0
	elif Input.is_action_just_pressed("jump") and velocity.y > 0.0:
		velocity.y = 5.0
	
	#END JUMP/FALL
	
	move_and_slide()
	
	
		
	
	if Input.is_action_pressed("Shoot") and %Timer.is_stopped(): 
		shoot_bullet()
	
	
func shoot_bullet():
	const BULLET_3D = preload("res://Scenes/Bullet3D.tscn")
	
	#Old shooting code:	
	#var new_bullet = BULLET_3D.instantiate()
	#%Marker3D.add_child(new_bullet)
	#new_bullet.global_transform = %Marker3D.global_transform
	
	var camera = %Camera3D
	var viewport = get_viewport()
	
	var screen_center = viewport.get_visible_rect().size * 0.5
	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_dir = camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + ray_dir * 1000
	
	var space_state = get_world_3d().direct_space_state
	var test = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	test.exclude = [self]
	
	var res = space_state.intersect_ray(test)
	var target = res.position if res else ray_end
	
	var bullet = BULLET_3D.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = %Marker3D.global_position
	var direction = -(target - bullet.global_position).normalized() #if i shoot backwards, flip the sign
	bullet.global_transform.basis = Basis.looking_at(direction, Vector3.UP)
	
	%Timer.start()

func take_player_damage():
	playerHp -= 5
	playerHp = max(0, playerHp)
	healthBar.value = playerHp
	print("The player has taken 5 damage.")
	print(playerHp)
	
func _ready():
	print("Loaded children: ", get_tree().root.get_children())
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	healthBar.max_value = maxHp
	healthBar.value = playerHp
	healthBar.min_value = 0
	
	
func _on_area_3d_body_entered(body):
	if body.has_method("do_damage"):
		take_player_damage()
