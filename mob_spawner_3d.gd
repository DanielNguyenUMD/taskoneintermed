extends Node3D


@export var mobSpawnType: PackedScene = null
@onready var marker_3d = %Marker3D
@onready var timer = %Timer

func _on_timer_timeout():
	var new_mob = mobSpawnType.instantiate()
	add_child(new_mob) 
	new_mob.global_position = marker_3d.global_position
