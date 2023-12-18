extends State

func enter_state(_prev_state : State):
	previous_state = _prev_state
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if actor.velocity.y > 0 and actor.is_on_floor():
		transition.emit(previous_state.name)
	
	actor.move_and_slide()
