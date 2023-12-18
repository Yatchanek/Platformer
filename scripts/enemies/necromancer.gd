extends CharacterBody2D
class_name  Necromancer

@export var enemies : Node2D

@onready var state_machine : FiniteStateMachine = $FiniteStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var potential_targets : Array = []

func _on_revive_timer_timeout():
	if scan_for_targets():
		state_machine.transition("NecromancerCastState")
	
func scan_for_targets() -> bool:
	potential_targets = []
	for target in enemies.get_children():
		if target is Skeleton and target.is_dead and target.is_on_screen:
			potential_targets.append(target)
	return potential_targets.size() > 0
