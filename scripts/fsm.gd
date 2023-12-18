extends Node
class_name FiniteStateMachine

@export var current_state : State
@export var animator : AnimationPlayer
@export var actor : CharacterBody2D
@export var pivot : Marker2D

var previous_state : State

var states = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(transition)
			child.animator = animator
			child.actor = actor
			child.pivot = pivot
			
	if current_state:
		change_state(previous_state, current_state)

func transition(new_state : String):
	previous_state = current_state
	current_state.is_current = false
	change_state(previous_state, states[new_state])

func change_state(_previous_state: State, new_state : State):
	if new_state is State:
		if current_state:
			current_state.exit_state()
		new_state.enter_state(previous_state)
		new_state.is_current = true
		current_state = new_state

func execute_command(command : Forresta.Commands):
	return current_state.execute_command(command)

func _process(delta):
	if current_state:
		current_state.frame_update(delta)

func _physics_process(delta) -> void:
	if current_state:
		current_state.physics_update(delta)
		
func _on_animation_finished(_anim_name : String) -> void:
	current_state.animation_finished()	
