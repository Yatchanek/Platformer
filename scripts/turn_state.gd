extends State
class_name TurnState

func enter_state(prev_state : State):
	animator.play("Turn")
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Turn":
		transition.emit("RunState")
