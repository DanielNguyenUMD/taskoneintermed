extends Node3D

@onready var animation_tree = %AnimationTree
@onready var mob_mesh := $bat
@onready var animation_player = %AnimationPlayer

func hurt():
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	
	
	
