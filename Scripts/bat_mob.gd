extends RigidBody3D

var health = 3
@onready var bat_model = %bat_model
var spd = randf_range(2.0,4.0)
var deathFlag = false

@onready var player = get_node("/root/game/Player")

func _physics_process(_delta):
	
		var horizontal_dir = Vector3(player.global_position.x - global_position.x, 0, player.global_position.z - global_position.z).normalized()	
	
		linear_velocity.x = horizontal_dir.x * spd
		linear_velocity.z = horizontal_dir.z * spd
	
		var target_y = player.global_position.y + 1.0
		var height_diff = target_y - global_position.y
		var vert_spd = 2.0
		linear_velocity.y = clamp(height_diff * vert_spd, -spd, spd)
			
		var dist_to_player = global_position.distance_to(player.global_position)
		if dist_to_player > 0.5:
			var look_target = player.global_position
			look_target.y = global_position.y
		
			if abs(look_target.x - global_position.x) < 0.1 and abs(look_target.z - global_position.z) < 0.1:
				look_target.x += 0.1
			else:
				look_target.y = global_position.y
		
			bat_model.look_at(look_target, Vector3.UP)
		bat_model.rotate_y(PI)
	
	#var direction = global_position.direction_to(player.global_position)
	#direction.y = 0.0
	#linear_velocity = direction * spd
	#bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI

func do_damage():
	print("I have dealt damage")
	
func take_damage():
	bat_model.hurt()
	
	health -= 1
	if(health == 0):
		queue_free()
