extends EnemyAttackState

var attack_ended : bool = false
var attack_cooldown : float = 0.3

func physics_update(delta):
	if attack_ended:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			attack_ended = false
			attack_cooldown = 0.3
			animator.play("Attack", -1, 1.0)

func animation_finished():
	actor.turn_to_player()
	if not actor.player_detector.is_colliding():
		transition.emit("ChaseState")
	else:
		attack_ended = true
		attack_cooldown = 0.3
