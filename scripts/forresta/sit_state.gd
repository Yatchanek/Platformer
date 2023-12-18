extends State
class_name SitState

var tw : Tween
	
func enter_state(_previous_state: State):
	animator.play("Sit", -1, 2.0)
	actor.velocity.x = 0
#	tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
#	tw.tween_property(actor.camera, "position:y", 64.0, 0.75)

func exit_state():
	pass
#	if tw:
#		tw.kill()
#	tw = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
#	tw.tween_property(actor.camera, "position:y", 0.0, 0.75)
	
func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	


	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		pivot.scale.x = sign(direction)
	
	actor.move_and_slide()

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.RELEASE and not actor.ceiling_detector.is_colliding():
		transition.emit("StandUpState")
	return true
