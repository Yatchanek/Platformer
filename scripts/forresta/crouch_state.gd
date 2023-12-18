extends State
class_name CrouchState

func enter_state(_prev_state : State):
	animator.play("Crouch", -1, 1.5)
	actor.ceiling_detector.set_deferred("enabled", true)

	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
#	if not actor.is_on_floor():
#		transition.emit("FallState")
		

		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		pivot.scale.x = -direction

	actor.move_and_slide()


func animation_finished():
	transition.emit("SitState")

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.RELEASE and not actor.ceiling_detector.is_colliding():
		transition.emit("StandUpState")
	
	return true
