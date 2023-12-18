extends State
class_name WallSlideState

func enter_state(_prev_state : State) -> void:
	animator.play("WallSlide")
	actor.velocity.y = 0
	
func physics_update(delta):
	if not actor.ground_detector.is_colliding():
		actor.velocity.y += actor.gravity * 0.25 * delta

	else:
		transition.emit("IdleState")
	


	if not actor.lower_wall_detector.is_colliding():
		transition.emit("FallState")


	actor.move_and_slide()
	
func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
		
	if command == Forresta.Commands.JUMP:
		actor.velocity.y = actor.JUMP_VELOCITY
		actor.velocity.x = actor.get_wall_normal().x * actor.SPEED * 0.75
		pivot.scale.x = sign(actor.velocity.x)
		transition.emit("JumpState")
	
	return true
