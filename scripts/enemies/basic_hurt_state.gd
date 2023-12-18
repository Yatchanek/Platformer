extends State
class_name BasicHurtState

func enter_state(_prev_state : State):
	animator.play("Hurt", -1, 2.0)
	actor.velocity = Vector2.ZERO
	previous_state = _prev_state
#	var initial_modulate = actor.sprite.modulate
#	var tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
#	tw.tween_property(actor.sprite, "modulate", Color.WHITE, 0.1)
#	tw.tween_property(actor.sprite, "modulate", initial_modulate, 0.1)

func animation_finished():
	actor.turn_to_player()
	actor.invul_timer.start()
	transition.emit("PatrolState")

