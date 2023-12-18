extends State
class_name SlimePatrolState

var can_move : bool = true
var move_cooldown : float


func enter_state(_prev_state : State):
	actor.check_for_player()
	move_cooldown = 0.25
	if !actor.target:
		actor.SPEED = 32
		animator.play("Walk", -1, 1.0)
	else:
		actor.SPEED = 64
		animator.play("Walk" ,-1, 2.0)
	
	actor.velocity.x = pivot.scale.x * actor.SPEED
	

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
		
	if can_move:	
		actor.velocity.x = pivot.scale.x * actor.SPEED
			
		actor.move_and_slide()
	else:
		move_cooldown -= delta
		if move_cooldown <= 0:
			can_move = true
			move_cooldown = randf_range(0.5, 1.0)
			if actor.target:
				move_cooldown = 0.25
				actor.SPEED = 64
				animator.play("Walk", -1, 2.0)
			else:
				move_cooldown = 0.5
				actor.SPEED = 32
				animator.play("Walk", -1, 1.0)
	if actor.player_detector.is_colliding() and actor.can_attack:
		actor.target = actor.player_detector.get_collider()
		transition.emit("AttackState")
		
		
func animation_finished():
	can_move = false
	actor.check_for_edges()
	actor.check_for_player()


