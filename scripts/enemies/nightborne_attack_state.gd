extends EnemyAttackState

var attack_finished : bool = false
var attack_cooldown : float = 0.3

func enter_state(_previous_state : State):
	animator.play("Attack", -1, actor.attack_anim_speed)

func frame_update(delta):
	if attack_finished:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			attack_finished = false
			if actor.player_detector.is_colliding():
				transition.emit("AttackState")
			elif actor.can_see_player():
				transition.emit("ChaseState")
			else:
				transition.emit("IdleState")

func animation_finished():
	actor.turn_to_player()
	actor.can_attack = false
	actor.attack_cooldown_timer.start()
	if actor.is_too_close():
		await get_tree().create_timer(0.25).timeout
		if not actor.is_dead:
			transition.emit("TeleportState")
			return	
	else:
		if actor.player_detector.is_colliding():
			transition.emit("AttackState")
		elif actor.can_see_player():
			transition.emit("ChaseState")
		else:
			transition.emit("IdleState")
