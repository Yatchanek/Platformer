extends State
class_name EnemyDieState

signal died


func enter_state(_prev_state : State):
	if actor.is_dead:
		return
	died.connect(actor._on_died)
	actor.is_dead = true
	actor.health_bar.hide()
	animator.play("Die", -1, actor.die_anim_speed)
	actor.velocity = Vector2.ZERO


func animation_finished():
	await get_tree().create_timer(0.5).timeout
	died.emit()
