extends Area2D
class_name AttackBox

@export var attacker : Node2D
@onready var collision : CollisionShape2D = $CollisionShape2D

func activate():
	collision.set_deferred("disabled", false)
	
func deactivate():
	collision.set_deferred("disabled", true)
