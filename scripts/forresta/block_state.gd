extends State
class_name BlockState

func enter_state(_previous_state : State):
	animator.stop()
	actor.velocity.x = 0
	actor.sprite.frame = 22
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	var initial_vel = actor.velocity.x
	actor.velocity.x = move_toward(actor.velocity.x, 0.0, actor.SPEED * delta * 3)
	
	if initial_vel != 0 and actor.velocity.x == 0:
		if actor.Stats.current_stamina <= 1.0:
			transition.emit("IdleState")
			return
	
	
	if not actor.is_on_floor():
		transition.emit("FallState")
		
	actor.move_and_slide()

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.RELEASE:
		transition.emit("IdleState")
	return true

