extends EnemyIdleState

var turn_interval : float

func enter_state(_previous_state : State):
	super(_previous_state)
	turn_interval = randf_range(4.0, 5.0)

func frame_update(delta):
	turn_interval -= delta
	if turn_interval <= 0:
		turn_interval = randf_range(4.0, 5.0)
		pivot.scale.x = -pivot.scale.x

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	if actor.player_detector.is_colliding():
		transition.emit("RunState")
		return
	
	if actor.can_see_player():
		if actor.can_attack:
			transition.emit("AttackState")

	actor.move_and_slide()
