extends State

var target_lost : bool
var resign_countdown : float
var jump_initiated : bool
var jump_speed : float

func enter_state(_previous_state : State):
	animator.play("Run", -1, actor.run_anim_speed * 1.35)
	actor.SPEED = actor.chase_speed
	target_lost = false
	resign_countdown = 2.0
	jump_initiated = false
	
func frame_update(delta):
	if target_lost:
		resign_countdown -= delta
		if resign_countdown <= 0:
			transition.emit("IdleState")
		
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	actor.velocity.x = move_toward(actor.velocity.x, pivot.scale.x * actor.SPEED, actor.SPEED * delta * 5)
	
	if actor.wall_detector.is_colliding(): 
		pivot.scale.x = -pivot.scale.x
	
	if not actor.gap_detector.is_colliding():
		jump_speed = actor.calculate_jump()
		if jump_speed > 0:
			actor.velocity.x = pivot.scale.x * actor.SPEED
			actor.velocity.y = -jump_speed
			transition.emit("JumpState")
			return
		else:
			actor.velocity.x = 0
			pivot.scale.x *= -1
			if not actor.can_see_player():
				transition.emit("PatrolState")
			return

	if actor.ran_too_far():
		pivot.scale.x =- pivot.scale.x	
		
	actor.move_and_slide()
	
	if actor.can_see_player():
		if target_lost:
			target_lost = false
		
	elif not target_lost:
		target_lost = true
		resign_countdown = 2.0	
		
	if actor.player_detector.is_colliding() and actor.can_attack:
		transition.emit("AttackState")
		

