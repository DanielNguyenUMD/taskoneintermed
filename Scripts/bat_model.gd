extends Node3D

@onready var animation_tree = %AnimationTree
@onready var mob_mesh := $bat
@onready var animation_player = %AnimationPlayer

func hurt():
	animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func death():
	animation_player.play("Custom/Death")
	
func enable_transparency():
	var material = mob_mesh.get_active_material(0)
	if(material == null):
		return
	material = material.duplicate()
	mob_mesh.set_surface_override_material(0, material)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.6
	
func fade_out(duration := 1):
	enable_transparency()
	var material = mob_mesh.get_active_material(0)
	var tween = create_tween()
	tween.tween_property(material, "albedo_color:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	
	
