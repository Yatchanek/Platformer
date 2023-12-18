extends State
class_name BasicPatrolState

func enter_state(_prev_state : State):
	actor.velocity.x = pivot.scale.x * actor.SPEED
	animator.play("Walk")

func physics_update(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	if not actor.gap_detector.is_colliding() or actor.wall_detector.is_colliding():
		pivot.scale.x *= -1
	
	if actor.player_detector.is_colliding():
		transition.emit("AttackState")
	
	actor.velocity.x = pivot.scale.x * actor.SPEED
		
	actor.move_and_slide()
