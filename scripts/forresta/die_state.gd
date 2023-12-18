extends State
class_name DieState

var drown_time_limit : float

func enter_state(_prev_state : State) -> void:
	actor.velocity.x = 0.0
	actor.is_dead = true
	if not _prev_state is DrownState:
		animator.play("Die")
	else:
		actor.release_soul()
		var tw = create_tween().set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(actor.sprite, "modulate:a", 0.0, 0.15)

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	actor.move_and_slide()


func animation_finished():
	actor.die()

