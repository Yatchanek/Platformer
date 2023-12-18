extends EnemyAttackState


func animation_finished():
	actor.can_attack = false
	actor.attack_cooldown_timer.wait_time = randf_range(0.5, 0.8)
	actor.attack_cooldown_timer.start()
	transition.emit("IdleState")
