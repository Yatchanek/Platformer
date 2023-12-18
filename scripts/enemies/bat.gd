extends CharacterBody2D
class_name Bat

@export var speed : int
@export var hp : float
@export var max_left : int
@export var max_right : int
@export var max_up : int
@export var max_down : int
@export var max_radius : int

@onready var up : RayCast2D = $Pivot/WallDetectors/Up
@onready var down : RayCast2D = $Pivot/WallDetectors/Down

@onready var right : RayCast2D = $Pivot/WallDetectors/Right
@onready var state_machine : FiniteStateMachine = $FiniteStateMachine

var affinity = Globals.Affinities.NONE

signal died

func _ready():
	add_to_group("Enemies")
	if not max_left or not max_right or not max_up or not max_down:
		max_up = position.y - max_radius
		max_down = position.y + max_radius
		max_left = position.x - max_radius
		max_right = position.x + max_radius	

func take_damage(enemy : Node2D):
	var damage_taken = enemy.damage
	damage_taken *= Globals.affinity_interactions[affinity][enemy.affinity]
	hp -= damage_taken
	if hp > 0:
		state_machine.transition("HurtState")
	else:
		state_machine.transition("DieState")
