extends State
class_name  JumpState

var dust_scene = preload("res://scenes/dust.tscn")

var last_dir : int = 1


func enter_state(_prev_state : State):
	animator.play("Jump", -1, 1.0)
	var dust = dust_scene.instantiate()
	dust.global_position = actor.global_position
	actor.effect_spawned.emit(dust)
	
func physics_update(delta) -> void:
	actor.velocity.y += actor.gravity * delta
	
	if not actor.upper_wall_detector.is_colliding() and actor.ground_detector.is_colliding() and not actor.ground_detector.is_colliding():
		var point = actor.lower_wall_detector.get_collision_point()
		if pivot.scale.x > 0:
			actor.global_position.x = point.x
		else:
			actor.global_position.x =  point.x

		transition.emit("EdgeGrabState")
		

		
	if actor.velocity.y > 0:
		transition.emit("FallState")
	
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED * actor.AIR_RESISTANCE, actor.SPEED * 0.1)
		
	else:
		actor.velocity.x = move_toward(actor.velocity.x,0, actor.SPEED * 0.025)
		

	if actor.velocity.x !=0:
		pivot.scale.x = sign(actor.velocity.x)
		actor.hand_collision.position.x = pivot.scale.x * 10
	actor.move_and_slide()
	

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
		
	if command == Forresta.Commands.DASH:
		if actor.dash():
			transition.emit("DashState")
			return
		else:
			actor.no_stamina.emit()
	
	elif actor.can_climb and command == Forresta.Commands.JUMP:
		transition.emit("LadderClimbState")
	return true
