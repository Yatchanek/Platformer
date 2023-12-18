extends State
class_name CastState

func enter_state(_prev_state : State):
	actor.velocity.x = 0
	animator.play("Cast", -1, 1.5)
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if not actor.is_on_floor():
		transition.emit("FallState")
		
	actor.move_and_slide()
	
func animation_finished():
	transition.emit("IdleState")
