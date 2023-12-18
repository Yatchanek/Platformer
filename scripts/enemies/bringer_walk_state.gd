extends State

var direction : float
var direction_changed : bool = false

var target_lost : bool
var target_lost_countdown : float = 2.0
var cast_chance : float

func enter_state(_previous_state : State):
	actor.target = Globals.player
	actor.SPEED = actor.chase_speed
	target_lost = false
	if actor.player_too_close:
		direction_changed = true
		direction = -pivot.scale.x
		animator.play_backwards("Walk")
	else:
		direction_changed = false
		direction = pivot.scale.x
		animator.play("Walk", -1, 1.0)
	target_lost_countdown = 2.0
	cast_chance = 0.01

func frame_update(delta):
	if target_lost:
		target_lost_countdown -= delta
		if target_lost_countdown <= 0:
			transition.emit("IdleState")
			target_lost = false
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	if direction_changed and actor.retreated_too_far():
		direction_changed = false
		actor.velocity.x = 0
		direction = pivot.scale.x
		animator.play("Walk", -1, 1.0)
		
	elif not direction_changed and actor.player_too_close:
		direction_changed = true
		actor.velocity.x = 0
		direction = -pivot.scale.x
		animator.play_backwards("Walk")	
	
	if not actor.gap_detector.is_colliding():
		if target_lost:
			transition.emit("IdleState")
			return
		else:
			actor.velocity.x = 0
			animator.play("Idle")
			cast_chance = 0.03
		
	if actor.wall_detector.is_colliding():
		actor.velocity.x = 0
		pivot.scale.x *= -1
	
	if actor.player_detector.is_colliding():
		if not actor.player_too_close and actor.can_attack:
			transition.emit("AttackState")
			return

	if actor.back_wall_detector.is_colliding() or not actor.back_gap_detector.is_colliding() and direction_changed:
		actor.velocity.x = 0
		transition.emit("FleeState")
		return
		
	actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED, actor.SPEED * delta)
	
	if actor.can_cast_spell and randf() < cast_chance and actor.can_see_player():
		actor.can_cast_spell = false
		transition.emit("CastState")
		return
	
	if actor.ran_too_far():
		actor.velocity.x = 0
		pivot.scale.x *= -1
		if animator.current_animation == "Idle":
			animator.play("Walk", -1, 1.0)
			cast_chance = 0.01
	
	if not actor.can_see_player() and not target_lost:
		target_lost = true
		target_lost_countdown = 2.0
	
	if actor.can_see_player() and target_lost:
		target_lost = false
		target_lost_countdown = 2.0

	actor.move_and_slide()

func backing_too_far():
	return actor.is_facing_player() and abs(actor.global_position.x - Globals.player.global_position.x) > actor.max_overrun_distance
