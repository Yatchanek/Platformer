extends Area2D
class_name HurtBox

@export var target : CharacterBody2D

func _on_area_entered(area : Area2D):
	target.take_damage(area.attacker)

func deactivate():
	$CollisionShape2D.set_deferred("disabled", true)
	
func activate():
	$CollisionShape2D.set_deferred("disabled", false)
