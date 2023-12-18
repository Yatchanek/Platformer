extends EnemyIdleState

func frame_update(delta):
	actor.turn_interval -= delta
	if actor.turn_interval < 0:
		actor.turn_interval = randf_range(3.0, 5.0)
		if not actor.has_been_attacked and randf() < 0.5:
			pivot.scale.x *= -1
		if randf() < 0.25:
			transition.emit("PatrolState")

func physics_update(_delta):
	if actor.player_detector.is_colliding() and actor.can_attack:
		transition.emit("AttackState")
