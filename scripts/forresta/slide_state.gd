extends State
class_name GroundSlideState

func enter_state(_prev_state : State):
	actor.ceiling_detector.set_deferred("enabled", true)
	actor.ground_detector.target_position.y = 16 
	animator.play("Slide", -1, 0.9)

func exit_state():
		actor.ground_detector.target_position.y = 8
	
func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	if not actor.ground_detector.is_colliding() and not actor.ceiling_detector.is_colliding():
		transition.emit("FallState")
	
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.ACCELERATION * 0.00005)	
	actor.move_and_slide()

func animation_finished():
	if actor.ceiling_detector.is_colliding():
		transition.emit("DieState")
	else:
		transition.emit("RunState")

