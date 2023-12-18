extends State
class_name SlideState

func enter_state(prev_state : State):
	animator.play("Slide")
	
func physics_update(delta):
	if not actor.ground_detector.is_colliding():
		transition.emit("FallState")
	actor.move_and_slide()
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Roll":
		if actor.is_on_floor():
			transition.emit("RunState")
		else:
			transition.emit("FallState")
