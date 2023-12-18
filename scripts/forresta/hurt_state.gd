extends State
class_name HurtState

func enter_state(_prev_state : State):
	animator.play("Hurt", -1, 2.0)
	actor.velocity = Vector2.ZERO

func exit_state():
	actor.sprite.modulate = Color.WHITE

func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	actor.move_and_slide()

	
func animation_finished():
	transition.emit("IdleState")
