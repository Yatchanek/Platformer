extends State

func enter_state(_previous_state : State):
	animator.stop()
	pivot.rotation -= pivot.scale.x * PI / 4
	actor.velocity = Vector2(-pivot.scale.x * actor.SPEED * 1.25, actor.JUMP_VELOCITY * 0.5)
	actor.sprite.frame = 37
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED * delta)
	
	if actor.is_on_floor() and actor.velocity.y > 0:
		pivot.rotation = 0
		transition.emit("IdleState")
	
	actor.move_and_slide()
