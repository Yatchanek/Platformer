extends State


func enter_state(_prev_state : State):
	animator.play("Fall", -1, 1.0)

	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.is_on_floor():
		transition.emit("ChaseState")
	
	actor.move_and_slide()
