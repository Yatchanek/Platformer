extends State
class_name EdgeHangState

var stamina : float

func enter_state(_prev_state : State):
	stamina = 5.0
	animator.play("EdgeHang", -1, 0.5)
	actor.velocity = Vector2.ZERO

func exit_state():
	actor.hand_collision.set_deferred("disabled", true)
	actor.body_collision.set_deferred("disabled", false)

func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	stamina -= delta
	if stamina < 0:
		transition.emit("WallSlideState")
		

	
	if actor.ground_detector.is_colliding():
		transition.emit("IdleState")
		
	actor.move_and_slide()

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.JUMP:
		actor.velocity.y = actor.JUMP_VELOCITY
		actor.velocity.x = -pivot.scale.x * actor.SPEED * 0.75
		pivot.scale.x = sign(actor.velocity.x)
		transition.emit("JumpState")

	elif command == Forresta.Commands.CROUCH:
		transition.emit("WallSlideState")

	return true
