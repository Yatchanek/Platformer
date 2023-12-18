extends State
class_name DrownState

func enter_state(_previous_state : State):
	actor.sprite.z_index = -5
	actor.gravity = Globals.gravity * 0.03
	actor.velocity.x = 0
	actor.velocity.y = 0
	
func exit_state():
	actor.gravity = Globals.gravity
	
func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	
	actor.move_and_slide()
