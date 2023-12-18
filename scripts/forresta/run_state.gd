extends State
class_name RunState

var ghost_sprite_scene = preload("res://scenes/ghost_sprite.tscn")

var was_on_floor : bool = false
var transition_done : bool

signal ghost_spawned(ghost : Sprite2D)

func enter_state(prev_state : State) -> void:
	transition_done = false
	animator.play("Run", -1, 1.4)
	if prev_state is DashState:
		actor.velocity.x = pivot.scale.x * actor.SPEED

func physics_update(delta):
	actor.velocity.y += actor.down_gravity * delta
	if was_on_floor:
		actor.coyote_timer.start()
	if not actor.ground_detector.is_colliding() and actor.coyote_timer.time_left <= 0:
		transition.emit("FallState")
		
	if actor.jump_buffer:
		if actor.can_climb and not actor.on_top_of_ladder:
			transition.emit("LadderClimbState")
			transition_done = true
		else:
			actor.velocity.y = actor.JUMP_VELOCITY
			transition.emit("JumpState")
	
	
	if not transition_done:	
		var direction : float = Input.get_axis("ui_left", "ui_right")
			
		if direction:
			actor.velocity.x = move_toward(actor.velocity.x, direction * actor.SPEED, actor.ACCELERATION * delta)
			if actor.velocity.x != 0:
				pivot.scale.x = sign(actor.velocity.x)
				actor.hand_collision.position.x = pivot.scale.x * 10
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.FRICTION * delta)
			if abs(actor.velocity.x) < 1.0:
				actor.velocity.x = 0
				transition.emit("IdleState")
			if actor.velocity.x != 0:
				pivot.scale.x = sign(actor.velocity.x)	
				actor.hand_collision.position.x = pivot.scale.x * 10
							
		was_on_floor = actor.is_on_floor()	
		actor.move_and_slide()


func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if (command == Forresta.Commands.JUMP and (actor.is_on_floor() or actor.coyote_timer.time_left > 0.0)) or actor.jump_buffer:
		actor.velocity.y = actor.JUMP_VELOCITY
		transition.emit("JumpState")
		actor.coyote_timer.stop()

	elif command == Forresta.Commands.SLIDE:
		transition.emit("GroundSlideState")
		
	elif command == Forresta.Commands.ATTACK or actor.attack_buffer:
		transition.emit("AttackState")
		transition_done = true
		
	elif command == Forresta.Commands.STRONG_ATTACK and actor.Stats.current_stamina >= 3.0 and actor.is_on_floor():
		actor.strong_attack = true
		transition.emit("AttackState")
		transition_done = true
		
	elif command == Forresta.Commands.CROUCH and actor.is_on_floor():
		transition.emit("CrouchState")
		transition_done = true

	elif command == Forresta.Commands.DASH:
		if actor.dash():
			transition.emit("DashState")
		else:
			actor.no_stamina.emit()

	elif command == Forresta.Commands.BLOCK and actor.Stats.current_stamina >= 1:
		transition.emit("BlockState")
		transition_done = true

	elif command == Forresta.Commands.CAST:
		transition.emit("CastState")
		transition_done = true
	return true 
	
func _on_coyote_timer_timeout():
	pass


