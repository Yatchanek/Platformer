extends State
class_name NightBorneChaseState

var turns : int = 0
var tick : int = 0 

var target_lost_countdown : float

func enter_state(_previous_state : State):
	tick = 0
	animator.play("Run", -1, 2.5)
	target_lost_countdown = 1.5
	actor.target_lost = false

func frame_update(delta):
	if not actor.target_lost:
		return
		
	target_lost_countdown -= delta
	if target_lost_countdown <= 0:
		transition.emit("IdleState")
		
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	if not actor.can_see_player() and not actor.target_lost:
		actor.target_lost = true
		
	if actor.can_see_player() and actor.target_lost:
		target_lost_countdown = 1.5
		actor.target_lost = false
		
	if not actor.gap_detector.is_colliding():
		var jump_speed = actor.calculate_jump()
		if jump_speed > 0:
			actor.velocity.x = pivot.scale.x * actor.SPEED
			actor.velocity.y = -jump_speed
			transition.emit("JumpState")
			return
		else:
			actor.velocity.x = 0
			pivot.scale.x *= -1
			
	if actor.wall_detector.is_colliding():
		actor.velocity.x = 0
		pivot.scale.x *= -1
		
	actor.velocity.x = move_toward(actor.velocity.x, pivot.scale.x * actor.SPEED, 4 * actor.SPEED * delta)
		
	actor.move_and_slide()
	
	if actor.player_detector.is_colliding() and actor.can_attack:
		transition.emit("AttackState")

	if actor.ran_too_far():
		actor.velocity.x = 0
		pivot.scale.x *= -1
