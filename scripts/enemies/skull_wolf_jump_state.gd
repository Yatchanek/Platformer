extends State

func enter_state(_prev_state : State):
	previous_state = _prev_state
	
	
func physics_update(delta):
	if actor.sprite.frame == 11:
		animator.stop()
	actor.velocity.y += actor.gravity * delta
	if actor.velocity.y > 0:
		transition.emit("FallState")
	
	actor.move_and_slide()
