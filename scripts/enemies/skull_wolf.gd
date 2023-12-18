extends BasicEnemy

@onready var vision : RayCast2D = $Pivot/Vision

@export var patrol_speed : int
@export var chase_speed : int

var target_lost : bool

func can_see_player():
	if vision.is_colliding() and vision.get_collider() is Forresta:
		target_lost = false
		return true
	target_lost = true
	return false
