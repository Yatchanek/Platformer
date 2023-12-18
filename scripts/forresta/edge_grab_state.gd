extends State
class_name EdgeGrabState

func enter_state(_prev_state : State) -> void:
	if actor.ground_detector.is_colliding():
		transition.emit(_prev_state.name)
		return
	animator.play("EdgeGrab", -1, 1.0)
	actor.velocity = Vector2.ZERO
	actor.hand_collision.set_deferred("disabled", false)
	actor.body_collision.set_deferred("disabled", true)
	
func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	actor.move_and_slide()

func animation_finished():
	transition.emit("EdgeHangState")

