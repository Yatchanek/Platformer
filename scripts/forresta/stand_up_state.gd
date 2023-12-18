extends State
class_name StandUpState

func enter_state(_prev_state : State):
	animator.play("StandUp", -1, 2.0)

func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	actor.move_and_slide()

func animation_finished():
	if actor.ceiling_detector.is_colliding():
		transition.emit("DieState")
	elif actor.velocity.x != 0.0:
		actor.ceiling_detector.set_deferred("enabled", false)
		transition.emit("RunState")
	else:
		actor.ceiling_detector.set_deferred("enabled", false)
		transition.emit("IdleState")

