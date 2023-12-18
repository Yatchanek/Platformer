extends State
class_name TeleportState

func enter_state(_previous_state : State):
	actor.sprite.hide()
	animator.play("Teleport")


func animation_finished():
	transition.emit("IdleState")
