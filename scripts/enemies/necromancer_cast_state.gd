extends State
class_name NecromancerCastState

func enter_state(_previous_state: State):
	animator.speed_scale = 0.5
	animator.play("CastSpell")
	
func revive_skeletons():
	for target in actor.potential_targets:
		target.state_machine.transition("ReviveState")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "CastSpell":
		transition.emit("EnemyIdleState")
