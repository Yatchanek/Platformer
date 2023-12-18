extends State
class_name LadderClimbState

var tick : float

func enter_state(_previous_state : State):
	animator.stop()
	actor.velocity.x = 0
	actor.velocity.y = 0
	actor.sprite.frame = 91
	tick = 0
	if actor.current_ladder:
		actor.global_position.x = actor.current_ladder.global_position.x


func physics_update(delta):
	#if actor.can_climb:
	var direction_x : float = Input.get_axis("ui_left", "ui_right")
	var direction_y : float = Input.get_axis("ui_up", "ui_down")
	
	if direction_x or direction_y:
		actor.velocity.x = move_toward(actor.velocity.x, direction_x * actor.SPEED * 0.5, actor.SPEED * 0.1)
		actor.velocity.y = move_toward(actor.velocity.y, direction_y * actor.SPEED * 0.5, actor.SPEED * 0.1)
		tick += delta
		if tick > 0.05:
			tick = 0
			actor.sprite.frame = wrapi(actor.sprite.frame + 1, 91, 99)
			
	if not direction_y:
		actor.velocity.y = 0
	if not direction_x:
		actor.velocity.x = 0
	if actor.velocity.y > 1 and actor.ground_detector.is_colliding():
		transition.emit("IdleState")

	actor.move_and_slide()
