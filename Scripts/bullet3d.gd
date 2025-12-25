extends Area3D

@export var bulletSpd = 10.0
@export var rnge = 30.0

var travelledDis = 0.0

func _physics_process(delta):
	position += transform.basis.z * bulletSpd * delta
	travelledDis += bulletSpd * delta
	if travelledDis > rnge:
		queue_free()
	
