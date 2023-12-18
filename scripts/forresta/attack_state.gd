extends State
class_name AttackState

signal spawn_fireball()

@export var colors : Array[Color]

func enter_state(_prev_state : State):
	actor.attack_buffer = false
	var material = actor.sprite.get_material()
	material.set_shader_parameter("is_attacking", true)
	actor.velocity.x = 0
	if actor.strong_attack:
		actor.Stats.current_stamina -= 3.0
		animator.play("StrongAttack", -1, 1.05)
		actor.Stats.current_damage *= 2.0
	else:
		actor.combo_timer.stop()
		actor.attacks_performed += 1
		if actor.attacks_performed < 3:
			animator.play("Attack", -1, 1.6)
		else:
			animator.play("ComboAttack", -1, 1.6)

func exit_state():
	if actor.strong_attack:
		actor.Stats.current_damage *= 0.5
	actor.strong_attack = false
	var material = actor.sprite.get_material()
	material.set_shader_parameter("is_attacking", false)

func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	

		
	actor.move_and_slide()
	
func animation_finished():
	transition.emit("IdleState")
	actor.combo_timer.start()
	if actor.attacks_performed == 3:
		actor.attacks_performed = 0

func apply_effect():
	var material = actor.sprite.material
	material.set_shader_parameter("target_color", Globals.affinity_colors[actor.affinity])

func remove_effect():
	var material = actor.sprite.material
	material.set_shader_parameter("target_color", Color.WHITE)	

func execute_command(command : Forresta.Commands):
	if not accepted_commands.has(command) and command != Forresta.Commands.RELEASE:
		return false
	if command == Forresta.Commands.ATTACK:
		actor.attack_buffer = true
		actor.attack_buffer_timer.start()
	return true
