extends State

func enter_state(_prev_state : State):
	animator.play("Hurt", -1, 2.0)
	actor.velocity = Vector2.ZERO
	previous_state = _prev_state

func exit_state():
	actor.sprite.modulate = Color.WHITE

func animation_finished():
	actor.invul_timer.start()
	actor.turn_to_player()
	if actor.is_too_close():
		transition.emit("RunState")
		return
	else:
		transition.emit("IdleState")
