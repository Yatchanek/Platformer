extends State

var turn_interval : float

func enter_state(_previous_state : State):
	actor.velocity.x = 0
	animator.play("Idle", -1, 1.0)
	turn_interval = randf_range(4.0, 6.0)

func frame_update(delta):
	turn_interval -= delta
	if turn_interval <= 0:
		var chance = randf()
		if chance < 0.25:
			transition.emit("PatrolState")
		elif chance < 0.75:
			pivot.scale.x = -pivot.scale.x
			turn_interval = randf_range(4.0, 6.0)
		

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if actor.can_see_player():
		transition.emit("ChaseState")
	
	actor.move_and_slide()
