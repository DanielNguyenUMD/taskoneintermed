extends RigidBody3D

@onready var bat_model = %bat_model
var spd = randf_range(2.0, 10.0)

@onready var player = get_node("/root/game/Player")

func _physics_process(_delta):
	#var direction = global_position.direction_to(player.global_position)
	#direction.y = 0.0
	#linear_velocity = direction * spd
	#var target = player.global_position
	#target.y = global_position.y
	#bat_model.look_at(target, Vector3.UP)
	#bat_model.rotate_y(PI)
	var horizontal_dir = Vector3(player.global_position.x - global_position.x, 0, player.global_position.z - global_position.z).normalized()	
	
	linear_velocity.x = horizontal_dir.x * spd
	linear_velocity.z = horizontal_dir.z * spd
	
	#end horiz
	#begin vert
	
	var target_y = player.global_position.y + 1.0
	var height_diff = target_y - global_position.y
	var vert_spd = 2.0
	linear_velocity.y = clamp(height_diff * vert_spd, -spd, spd)
	
	#end vert
	
	var look_target = player.global_position
	look_target.y = global_position.y
	bat_model.look_at(look_target, Vector3.UP)
	
	bat_model.rotate_y(PI)

	
func take_damage():
	bat_model.hurt()
