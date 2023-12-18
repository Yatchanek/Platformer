extends State
class_name IdleState

func enter_state(_prev_state : State):
	animator.play("Idle", -1, 1.0)
	actor.velocity = Vector2.ZERO


func physics_update(delta):
	if actor.frozen:
		return
		
	actor.velocity.y += actor.down_gravity * delta
	
	if actor.jump_buffer:
		if actor.can_climb and not actor.on_top_of_ladder:
			transition.emit("LadderClimbState")
		else:
			actor.velocity.y = actor.JUMP_VELOCITY
			transition.emit("JumpState")
			
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		transition.emit("RunState")
		
	actor.move_and_slide()


func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.JUMP or actor.jump_buffer:
		if actor.can_climb and not actor.on_top_of_ladder:
			transition.emit("LadderClimbState")
		else:
			actor.velocity.y = actor.JUMP_VELOCITY
			transition.emit("JumpState")

			
	elif command == Forresta.Commands.CROUCH:
		if actor.on_top_of_ladder and actor.ladder_detector.is_colliding():
			actor.on_top_of_ladder.open()
			actor.current_ladder = actor.on_top_of_ladder
			actor.set_deferred("position", actor.position + Vector2(0, 24))
			transition.emit("LadderClimbState")
		else:
			transition.emit("CrouchState")		


	elif command == Forresta.Commands.ATTACK or actor.attack_buffer:
		transition.emit("AttackState")


	elif command == Forresta.Commands.STRONG_ATTACK and actor.Stats.current_stamina >= 3.0 and actor.is_on_floor():
		actor.strong_attack = true
		transition.emit("AttackState")

		
	elif command == Forresta.Commands.DASH:
		if actor.dash():
			transition.emit("DashState")
			
		else:
			actor.no_stamina.emit()
			return false
		
	elif command == Forresta.Commands.BLOCK and actor.Stats.current_stamina >= 1:
		transition.emit("BlockState")

		
	elif command == Forresta.Commands.CAST:
		transition.emit("CastState")

		
	return true
