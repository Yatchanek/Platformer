extends State

func enter_state(_previous_state : State):
	animator.play("Hurt", -1, 2.0)
	actor.velocity = Vector2.ZERO

func animation_finished():
	actor.turn_to_player()
	#actor.can_attack = true
	actor.invul_timer.start()
	actor.attack_cooldown_timer.start(0.2)
	transition.emit("ChaseState")

