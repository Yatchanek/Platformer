extends State
class_name NightBorneHurtState

func enter_state(_prev_state : State):
	animator.play("Hurt", -1, 3.0)
	actor.velocity = Vector2.ZERO
	previous_state = _prev_state
	

func animation_finished():
	actor.turn_to_player()
	actor.hurtbox.set_deferred("disabled", true)
	actor.invul_timer.start()
	if float(actor.hp) / float(actor.max_hp) < 0.25 and randf() < 0.75:
		transition.emit("TeleportState")
	elif actor.can_see_player():
		transition.emit("ChaseState")
	else:
		transition.emit("IdleState")
