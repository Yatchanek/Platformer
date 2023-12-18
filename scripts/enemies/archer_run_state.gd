extends State

var run_timer : float = 0.3
var run_delay : float = 0.75
var run_started : bool = false
var run_ended : bool = false

func enter_state(_previous_state : State):
	actor.is_running_away = true
	run_delay = 0.7
	if _previous_state.name == "HurtState" or _previous_state.name == "JumpState":
		run_delay = 0
	if not _previous_state.name == "JumpState":
		run_timer = 1.25

func exit_state():
	actor.is_running_away = false
	run_started = false

func frame_update(delta):
	if run_started:
		run_timer -= delta
	run_delay -= delta
	if run_delay <= 0 and not run_started:
		run_started = true
		if not actor.back_wall_detector.is_colliding() and actor.back_gap_detector.is_colliding():
			actor.turn_away_from_player()
		animator.play("Run", -1, 1.5)
	if run_timer <= 0.0:
		actor.turn_to_player()
		#run_started = false
		transition.emit("IdleState")

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	if !run_started:
		return
	actor.velocity.x = pivot.scale.x * actor.SPEED
	
	if not actor.gap_detector.is_colliding():
		var jump_speed = actor.calculate_jump()
		if jump_speed > 0:
			actor.velocity.y = -jump_speed
			transition.emit("JumpState")
			return
		else:
			actor.turn_to_player()
			#run_started = false
			transition.emit("IdleState")
			return
			
	if actor.wall_detector.is_colliding():
		actor.velocity.x = 0
		actor.turn_to_player()
		#run_started = false
		transition.emit("IdleState")


	actor.move_and_slide()
		
