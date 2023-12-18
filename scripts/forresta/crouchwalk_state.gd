extends State
class_name CrouchWalkState

var last_dir : int = 1

func enter_state(_prev_state : State):
	animator.play("CrouchWalk")
	animator.speed_scale = 1.0
	actor.ceiling_detector.enabled = true
	
func exit_state():
	animator.speed_scale = 1.5

func physics_update(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta
		transition.emit("FallState")
	
	if !Input.is_action_pressed("ui_down") and not actor.ceiling_detector.is_colliding():
		transition.emit("StandUpState")

	if Input.is_action_just_pressed("ui_accept"):
		transition.emit("AttackState")

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED * 0.5, actor.SPEED * 0.1)
		pivot.scale.x = sign(actor.velocity.x)
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)
		if actor.velocity.x < 5.0:
			actor.velocity.x = 0.0
			pivot.scale.x = last_dir
			transition.emit("CrouchState")
	last_dir = sign(actor.velocity.x)

	actor.move_and_slide()
