extends State

func enter_state(_prev_state : State):
	actor.turn_to_player()
	animator.play("Cast", -1, actor.default_anim_speed)
	
func animation_finished():
	actor.turn_to_player()
	actor.cast_spell_timer.start()
	transition.emit("ChaseState")
