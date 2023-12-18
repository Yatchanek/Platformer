extends State

var flee_cooldown : float

func enter_state(_previous_state : State):
	actor.turn_to_player()
	flee_cooldown = randf_range(1.0, 1.5)
	actor.SPEED = actor.flee_speed
	animator.play("Walk", -1, 1.2)
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if not actor.gap_detector.is_colliding() or actor.wall_detector.is_colliding():
		actor.velocity.x = 0
		pivot.scale.x *= -1
		
	actor.velocity.x = pivot.scale.x * actor.SPEED
	
	actor.move_and_slide()
	
	flee_cooldown -= delta
	if flee_cooldown <= 0:
		actor.turn_to_player()
		if actor.can_see_player():
			transition.emit("ChaseState")
		else:
			transition.emit("PatrolState")
