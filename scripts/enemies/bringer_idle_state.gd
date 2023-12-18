extends EnemyIdleState

var turn_cooldown : float

func enter_state(_previous_state : State):
	super(_previous_state)
	turn_cooldown = randf_range(2.5, 3.5)


func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if actor.can_see_player() and actor.gap_detector.is_colliding():
		actor.target = Globals.player
		transition.emit("ChaseState")
	else:
		actor.target = null
	
	if actor.player_detector.is_colliding() and actor.can_attack:
		if actor.global_position.distance_squared_to(Globals.player.global_position) > 2500:
			transition.emit("AttackState")
		else:
			transition.emit("ChaseState")
		
	actor.move_and_slide()
	
	turn_cooldown -= delta
	if turn_cooldown <= 0:
			turn_cooldown = randf_range(2.5, 3.5)
			if randf() < 0.5:
				pivot.scale.x *= -1
			else:
				transition.emit("PatrolState")
