extends CharacterBody2D
class_name Forresta

var fireball_scene = preload("res://scenes/fireball.tscn")
var dud_fireball_scene = preload("res://scenes/dud_fireball.tscn")
var label_scene = preload("res://scenes/info_label.tscn")
var ghost_scene = preload("res://scenes/ghost.tscn")
var potion_effect_scene = preload("res://scenes/potion_effect.tscn")

@export var Stats : StatsManager

@export var run_animation_speed : float = 1.4
@export var dash_cooldown_duration : float = 0.5
@export var dash_duration : float = 0.3
@export var effect_duration : float = 10.0
@export var dash_threshold : float = 5.0

@export var inventory : Resource
@export_range(0.05, 0.5, 0.05) var inertia : float = 0.15
@export_range(0.05, 0.5, 0.05) var brake_inertia : float = 0.1

@onready var state_machine : FiniteStateMachine = $FiniteStateMachine as FiniteStateMachine
@onready var pivot : Marker2D = $Marker2D
@onready var upper_wall_detector : RayCast2D  = $Marker2D/UpperWallDetector
@onready var lower_wall_detector : RayCast2D  = $Marker2D/LowerWallDetector
@onready var ground_detector : RayCast2D  = $GroundDetector
@onready var ceiling_detector : RayCast2D  = $CeilingDetector
@onready var ladder_detector : RayCast2D  = $LadderDetector
@onready var hand_collision : CollisionShape2D  = $HandCollision
@onready var body_collision : CollisionShape2D = $BodyCollision
@onready var coyote_timer : Timer = $CoyoteTimer
@onready var speed_boost_timer : Timer = $SpeedBoostTimer
@onready var strength_boost_timer : Timer = $StrengthBoostTimer
@onready var combo_timer = $ComboTimer
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var attack_buffer_timer = $AttackBufferTimer
@onready var sprite : Sprite2D = $Marker2D/Sprite2D
@onready var fireball_spawn_point : Marker2D = $Marker2D/FireballSpawnPoint
@onready var enemy_detector : RayCast2D = $Marker2D/EnemyDetector
@onready var dust : GPUParticles2D = $Dust
@onready var camera = $Camera
@onready var death_effect : GPUParticles2D = $Marker2D/DeathEffect
@onready var follow_point = $Marker2D/FollowPoint
@onready var debug_label = $DebugLabel

enum Effects {
	STR,
	SPD,
	ARM
}

var SPEED = 160
const DASH_SPEED = 400
var ACCELERATION : float = 480
var FRICTION : float = 640
const AIR_RESISTANCE : float = 0.9
var JUMP_VELOCITY : float
const JUMP_HEIGHT : int = 45
const DEFAULT_STATE : String = "IdleState"
const SPEED_BOOST : int = 112

var str_boost_time : float
var spd_boost_time : float
var arm_boost_time : float

var gravity = Globals.gravity
var down_gravity = gravity * 1.5

var affinity : Globals.Affinities
var fall_resistance : int = 10 * Globals.TILE_SIZE

var frozen : bool = true
var is_dead : bool = false
var is_teleporting : bool = false
var strong_attack : bool = false
var jump_buffer : bool = false
var attack_buffer : bool = false
var speed_boosted : bool = false

var will_o_wisp_following

var attacks_performed : int = 0

var can_climb : bool = false:
	set(value):
		can_climb = value
		if value == false and state_machine.current_state is LadderClimbState:
			state_machine.transition("IdleState")

var on_top_of_ladder : Ladder
var current_ladder : Ladder

const default_stats : Dictionary = {
	"strength" : 1,
	"constitution" : 1,
	"endurance" : 1,
	"agility" : 1,
	"max_mana" : 2
}

enum Commands {
	JUMP,
	ATTACK,
	STRONG_ATTACK,
	CROUCH,
	DASH,
	SLIDE,
	CAST,
	BLOCK,
	RELEASE,
	NULL
}

var command : Commands
var last_command : Commands
var last_event : int

signal fireball_spawned(fireball : Area2D)
signal ghost_spawned(ghost : Sprite2D)
signal soul_released(soul : Sprite2D)
signal teleport_ended
signal hp_changed(hp_percentage : float)
signal mana_changed(mana_percentage : float)
signal stamina_changed(stamina_precentage : float)
signal effect_spawned(effect : Node2D)
signal effect_duration_changed(type : Effects, effect_percentage : float)
signal effect_started(effect_color : Color)
signal effect_ended
signal stats_changed
signal no_stamina
signal no_mana
signal inventory_loaded
signal died


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_up"):
			command = Commands.JUMP
		if event.is_action_pressed("ui_down"):
			command = Commands.CROUCH
		if event.is_action_pressed("Attack"):
			command = Commands.ATTACK
		elif event.is_action_pressed("Block"):
			command = Commands.BLOCK
		elif event.is_action_pressed("Cast"):
			command = Commands.CAST
		elif event.is_action_pressed("Dash"):
			command = Commands.DASH
		elif event.is_action_pressed("Slide"):
			command = Commands.SLIDE
		elif event.is_action_pressed("StrongAttack"):
			command = Commands.STRONG_ATTACK	

		if not event.is_pressed():

			if event.keycode == last_event:
				command = Commands.RELEASE
			else:
				command = Commands.NULL
				last_command = Commands.NULL
				
		if command != last_command and command != Commands.NULL:
			var success = state_machine.execute_command(command)
			if success:
				last_command = command
				if event.is_pressed():
					last_event = event.keycode

					
func _ready():
	Globals.player = self
	startup()

func startup():
	command = Commands.NULL
	last_command = command
	calculate_physics_constants()

	if Globals.player_inventory:
		inventory = Globals.player_inventory
	else:
		inventory = Inventory.new()
	
	affinity = randi() % (Globals.Affinities.size() - 1) as Globals.Affinities
	
	EventBus.player_ready.emit(self)
	
	if not Globals.player_data:
		Stats = StatsManager.new()
		connect_stats_signals()
		Stats.initialize()
	
	else:
		Stats = Globals.player_data
		connect_stats_signals()
		Stats.current_hp = Stats.current_hp
		Stats.current_stamina = Stats.current_stamina
		Stats.current_mana = Stats.current_mana
	
func connect_stats_signals():
	var stat_signals = Stats.get_signal_list()
	for s in stat_signals:
		if ["changed", "setup_local_to_scene_requested", "script_changed", "property_list_changed"].has(s["name"]):
			continue
		else:
			var method_name : String = "_on_" + s["name"]
			Stats.connect(s["name"], Callable(self, method_name))
	
	
func calculate_physics_constants():
	JUMP_VELOCITY = -sqrt(2 * gravity * JUMP_HEIGHT)
	ACCELERATION = SPEED / inertia
	FRICTION = SPEED / brake_inertia

func _process(delta):
	if Stats.dash_cooldown >= 0:
		Stats.dash_cooldown -= delta
	if Stats.current_stamina < Stats.max_stamina:
		Stats.current_stamina += delta * 0.5
	if str_boost_time > 0:
		str_boost_time -= delta
		effect_duration_changed.emit(Effects.STR, str_boost_time / Stats.effect_duration * 100)
	if spd_boost_time > 0:
		spd_boost_time -= delta
		effect_duration_changed.emit(Effects.SPD, spd_boost_time / Stats.effect_duration * 100)
	if str_boost_time > 0:
		arm_boost_time -= delta
		effect_duration_changed.emit(Effects.ARM, arm_boost_time / Stats.effect_duration * 100)

func is_faceing_enemy(enemy : CharacterBody2D):
	return pivot.transform.x.dot(global_position.direction_to(enemy.global_position)) > 0

func launch_label(text : String):
	var label = label_scene.instantiate()
	label.initialize(text)
	label.global_position = global_position + Vector2.UP * 40
	get_parent().add_child(label)

func take_damage(enemy : Node2D):
	var damage_taken : float = Stats.calculate_received_damage(enemy)	
	
	if damage_taken < 0:
		launch_label("Miss!")
		return
	
	if state_machine.current_state is BlockState and enemy is CharacterBody2D and is_faceing_enemy(enemy):
		Stats.current_stamina -= enemy.power
		velocity.x = -pivot.scale.x * SPEED * 0.5 * enemy.power
		if Stats.current_stamina <= 0:
			state_machine.transition("IdleState")
		return
	
	launch_label("%d" % ceil(damage_taken))
	Stats.current_hp -= ceil(damage_taken)
	
	if Stats.current_hp > 0:
		if enemy is Hazard and enemy.is_lava_or_water:
			var tw = create_tween()
			tw.tween_property(sprite, "modulate", Color.RED, 0.1)
			tw.tween_property(sprite, "modulate", Color.WHITE, 0.1)
		else:
			state_machine.transition("HurtState")


func take_fall_damage(damage_taken : float):
	launch_label("%d" % ceil(damage_taken))
	Stats.current_hp -= ceil(damage_taken)
	if Stats.current_hp > 0:
		state_machine.transition("HurtState")

func dash() -> bool:
	return Stats.dash()
		

func heal():
	Stats.current_hp = Stats.max_hp
	play_potion_effect("res://resources/health_gradient_texture_1d.tres")


func restore_stamina():
	Stats.current_stamina = Stats.max_stamina
	play_potion_effect("res://resources/stamina_gradient_texture_1d.tres")

func restore_mana():
	Stats.current_mana = Stats.max_mana
	play_potion_effect("res://resources/ice_gradient_texture_1d.tres")

func speed_boost():
	if not speed_boosted:
		SPEED += SPEED_BOOST
		effect_started.emit(Effects.SPD)
		spd_boost_time = effect_duration
		speed_boost_timer.start(Stats.effect_duration)
		run_animation_speed = 2.0
		if state_machine.current_state is RunState:
			$AnimationPlayer.speed_scale = 1.66
	else:
		var extended_time = speed_boost_timer.time_left + Stats.effect_duration
		spd_boost_time = extended_time
		speed_boost_timer.start(extended_time)
	play_potion_effect("res://resources/acid_gradient_texture_1d.tres")

func strength_boost():
	if strength_boost_timer.is_stopped():
		Stats.boost_damage()
		effect_started.emit(Effects.STR)
		str_boost_time = Stats.effect_duration
		strength_boost_timer.start(Stats.effect_duration)
	else:
		var extended_time = speed_boost_timer.time_left + Stats.effect_duration
		str_boost_time = extended_time
		strength_boost_timer.start(extended_time)
	play_potion_effect("res://resources/strength_gradient_texture_1d.tres")

func upgrade_stat(stat : String, amount : int):
	Stats.change_stat_value(stat, amount)
	var text : String = stat.capitalize()
	launch_label("%s +%d" % [text, amount])
	stats_changed.emit()
			
func play_potion_effect(effect : String):
	var potion_effect : GPUParticles2D = potion_effect_scene.instantiate()
	potion_effect.process_material.color_ramp = load(effect)
	potion_effect.position = Vector2(0, -15)
	add_child(potion_effect)

func pick_up(object : Globals.Pickups) -> bool:
	return inventory.insert_item(object)


func check_for_key(key_type : Globals.Pickups) -> bool:
	return inventory.has(key_type)

func drown():
	state_machine.transition("DrownState")

func die():
	var tw = create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.tween_interval(0.5)
	tw.tween_property(sprite, "modulate:a", 0.0, 1.0)
	death_effect.emitting = true
	await get_tree().create_timer(3).timeout
	died.emit(not state_machine.previous_state is DrownState)

func release_soul():
	var ghost = ghost_scene.instantiate()
	ghost.global_position = global_position
	soul_released.emit(ghost)
	
func _on_speed_boost_timer_timeout():
	SPEED -= SPEED_BOOST
	run_animation_speed = 1.4
	$AnimationPlayer.speed_scale = 1.0
	effect_ended.emit(Effects.SPD)	
	
func _on_shrength_boost_timer_timeout():
	Stats.damage_boost_ended()
	effect_ended.emit(Effects.STR)
	
func _on_dash_state_ghost_spawned(ghost : Sprite2D):
	ghost_spawned.emit(ghost)


func spawn_fireball():
	var fireball
	if Stats.current_mana >= 1:
		Stats.current_mana -= 1
		fireball = fireball_scene.instantiate()
	else:
		fireball = dud_fireball_scene.instantiate()
		no_mana.emit()
	fireball.initialize(pivot.scale.x)
	fireball.global_position = fireball_spawn_point.global_position
	fireball_spawned.emit(fireball)
	

func teleport(target : Marker2D):
	sprite.hide()
	var tw = create_tween()
	tw.finished.connect(_on_teleported)
	tw.tween_interval(0.75)
	tw.tween_property(self, "global_position", target.global_position, 1.0)#global_position = target.global_position

func _on_teleported():
	teleport_ended.emit()
	state_machine.transition("TeleportState")


func _on_hp_changed(percentage : float):
	hp_changed.emit(percentage)

func _on_stamina_changed(percentage : float):
	stamina_changed.emit(percentage)

func _on_mana_changed(percentage : float):
	mana_changed.emit(percentage)

func _on_hp_depleted():
	state_machine.transition("DieState")

func _on_stats_updated():
	stats_changed.emit()

func reset():
	is_dead = false
	command = Commands.NULL
	str_boost_time = 0
	spd_boost_time = 0
	arm_boost_time = 0
	effect_ended.emit(Effects.STR)
	effect_ended.emit(Effects.SPD)
	effect_ended.emit(Effects.ARM)
	Stats.current_hp = Stats.max_hp
	#Stats.current_mana = Stats.max_mana
	Stats.current_stamina = Stats.max_stamina
	Stats.dash_cooldown = 0.3
	frozen = true
	sprite.modulate = Color.WHITE
	pivot.scale.x = 1
	sprite.z_index = 0
	state_machine.transition("IdleState")

func activate():
	frozen = false


func _on_jump_buffer_timer_timeout():
	jump_buffer = false


func _on_combo_timer_timeout():
	attacks_performed = 0


func _on_attack_buffer_timer_timeout():
	attack_buffer = false
