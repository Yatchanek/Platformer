extends State

var attack_cooldown : float

func enter_state(_previous_state : State):
	if not actor.is_facing_player():
		actor.turn_to_player()
	actor.can_attack = false
	actor.velocity.x = 0
	animator.play("Attack", -1, actor.attack_anim_speed)
	attack_cooldown = 1.0
	actor.attack_cooldown_timer.start()

func frame_update(delta):
	attack_cooldown -= delta
	if attack_cooldown <=0:
		if actor.player_detector.is_colliding():
			animator.play("Attack", -1, actor.attack_anim_speed)
			attack_cooldown = 1.0
			actor.attack_cooldown_timer.start()
		else:
			transition.emit("ChaseState")
		
func animation_finished():
	animator.play("Idle", -1, 1.0)
