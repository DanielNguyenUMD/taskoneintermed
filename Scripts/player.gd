extends CharacterBody3D

var cursorVisible = false
var mouseCounter = 0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.5
		%Camera3D.rotation_degrees.x -= event.relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)
	elif event.is_action_pressed("ui_cancel") and cursorVisible == false:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		cursorVisible = true
		mouseCounter += 1
		print(mouseCounter)
	elif event.is_action_pressed("ui_cancel") and cursorVisible == true:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		cursorVisible = false
		mouseCounter += 1
		print(mouseCounter)
		
func _physics_process(delta):
		
	var spd = 5.5
	
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
	
	velocity.y -= 5.0 * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += 5.0
	elif Input.is_action_just_pressed("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	#END JUMP/FALL
	
	move_and_slide()
	
	if Input.is_action_pressed("Shoot"): 
		shoot_bullet()
	
	
func shoot_bullet():
	const BULLET_3D = preload("res://Bullet3D.tscn")
	var new_bullet = BULLET_3D.instantiate()
	%Marker3D.add_child(new_bullet)
	
	new_bullet.global_transform = %Marker3D.global_transform
	
	%Timer.start()
	
	
	
	
		
func _ready():
	print("Loaded children: ", get_tree().root.get_children())
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	
	
	
	
