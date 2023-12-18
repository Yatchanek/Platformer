extends State
class_name FallState

var initial_height: int

func enter_state(_prev_state : State):
	animator.play("Fall")
	initial_height = int(actor.position.y)

func physics_update(delta) -> void:
	if not actor.is_on_floor():
		actor.velocity.y += actor.down_gravity * delta

		if actor.lower_wall_detector.is_colliding() and actor.upper_wall_detector.is_colliding():
			transition.emit("WallSlideState")
			
		elif not actor.upper_wall_detector.is_colliding() and actor.lower_wall_detector.is_colliding() and not actor.ground_detector.is_colliding():
			var point = actor.lower_wall_detector.get_collision_point()
			if pivot.scale.x > 0:
				actor.global_position.x =  point.x
			else:
				actor.global_position.x =  point.x
			transition.emit("EdgeGrabState")
				

		
	else:
		if actor.velocity.x != 0:
			transition.emit("RunState")
		else:
			transition.emit("IdleState")
		
		calculate_fall_damage()
		
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED * actor.AIR_RESISTANCE, actor.SPEED * 0.1)
		
	else:
		actor.velocity.x = move_toward(actor.velocity.x,0, actor.SPEED * 0.025)
	
	if actor.velocity.x != 0:
		pivot.scale.x = sign(actor.velocity.x)
		actor.hand_collision.position.x = pivot.scale.x * 10
	
	actor.move_and_slide()

func calculate_fall_damage():
	var height_diff : int = int(actor.position.y) - initial_height
	if height_diff > actor.fall_resistance:
		var excess_height = height_diff - actor.fall_resistance
		actor.take_fall_damage(floor(excess_height / Globals.TILE_SIZE))
	
func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if actor.can_climb and command == Forresta.Commands.JUMP:
		transition.emit("LadderClimbState")
		
	elif command == Forresta.Commands.DASH:
		if actor.dash():
			transition.emit("DashState")
			return
		else:
			actor.no_stamina.emit()
	
	elif command == Forresta.Commands.JUMP:
		actor.jump_buffer = true
		actor.jump_buffer_timer.start()
