extends State

func enter_state(_prev_state : State):
	animator.play("Hurt", -1, 4.0)
	actor.velocity.x = 0
	previous_state = _prev_state

func animation_finished():
	actor.turn_to_player()
	actor.hits_landed += 1
	actor.hurt_timer.start()
	if actor.hits_landed >= 3:
		transition.emit("FleeState")
		return
	if not previous_state.name == "HurtState" and not previous_state.name == "AttackState":
		transition.emit(previous_state.name)
	else:
		transition.emit("ChaseState")
