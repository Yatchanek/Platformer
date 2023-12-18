extends CharacterBody2D
class_name Skeleton

const SPEED = 16

var affinity : int

var is_dead : bool = false
var is_on_screen : bool = false
const DEFAULT_STATE : String = "PatrolState"

@export var hp : int = 2
@export var damage : int = 2

@onready var gap_detector = $Marker2D/GapDetector
@onready var wall_detector = $Marker2D/WallDetector
@onready var player_detector = $Marker2D/PlayerDetector
@onready var attack_cooldown_timer = $RestTimer
@onready var state_machine = $FiniteStateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	affinity = randi() % Globals.Affinities.size()

func take_damage(damage : int, attacker_affinity : int):
	if Globals.resistances[affinity].has(attacker_affinity):
		damage *= 0.5
	elif Globals.weaknesses[affinity].has(attacker_affinity):
		damage *= 1.5
	hp -= damage
	if hp > 0:
		state_machine.transition("HurtState")
	else:
		state_machine.transition("DieState")


func _on_visible_on_screen_enabler_2d_screen_exited():
	is_on_screen = false
	if not is_dead:
		state_machine.transition("IdleState")


func _on_visible_on_screen_enabler_2d_screen_entered():
	is_on_screen = true
	if not is_dead:
		state_machine.transition("PatrolState")


func _on_hurtbox_area_entered(_area : Area2D):
	take_damage(Globals.player.damage, Globals.player.affinity)
