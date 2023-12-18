extends State

var turn_interval : float

func enter_state(_previous_state : State):
	animator.play("Run", -1, actor.run_anim_speed)
	turn_interval = randf_range(6.0, 8.0)
	actor.SPEED = actor.patrol_speed
	
func frame_update(delta):
	turn_interval -= delta
	if turn_interval <= 0:
		var chance = randf()
		if chance < 0.25:
			transition.emit("IdleState")
		elif chance < 0.75:
			pivot.scale.x = -pivot.scale.x
			turn_interval = randf_range(6.0, 7.0)
		
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	actor.velocity.x = move_toward(actor.velocity.x, pivot.scale.x * actor.SPEED, actor.SPEED * delta * 5)
	
	if actor.wall_detector.is_colliding() or not actor.gap_detector.is_colliding():
		pivot.scale.x = -pivot.scale.x
	
	if actor.can_see_player():
		transition.emit("ChaseState")
		
	actor.move_and_slide()
