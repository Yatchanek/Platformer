extends State

var turn_cooldown : float

func enter_state(_previous_state : State):
	actor.target = null
	actor.SPEED = actor.patrol_speed
	turn_cooldown = randf_range(3.5, 4.5)
	animator.play("Walk", -1, 0.75)
	

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if not actor.gap_detector.is_colliding() or actor.wall_detector.is_colliding():
		actor.velocity.x = 0
		pivot.scale.x *= -1
		
	actor.velocity.x = move_toward(actor.velocity.x, pivot.scale.x * actor.SPEED, actor.SPEED * delta)
	
	if actor.can_see_player() and actor.gap_detector.is_colliding():
		transition.emit("ChaseState")
	
	actor.move_and_slide()
	
	turn_cooldown -= delta
	if turn_cooldown <= 0:
			turn_cooldown = randf_range(3.5, 4.5)
			if randf() < 0.25:
				actor.velocity.x = 0
				pivot.scale.x *= -1
			else:
				transition.emit("IdleState")
	
	
