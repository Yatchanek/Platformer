extends State
class_name DashState

var tick : int
var dash_duration : float 

var ghost_sprite_scene = preload("res://scenes/ghost_sprite.tscn")

signal ghost_spawned(ghost : Sprite2D)

func enter_state(prev_state : State) -> void:
	animator.play("Dash", -1, 1.0)
	tick = 0
	previous_state = prev_state
	actor.velocity.y = 0.0
	dash_duration = actor.dash_duration

func exit_state():
	actor.Stats.dash_cooldown = 0.25
	actor.velocity.x = 0

func frame_update(delta):
	dash_duration -= delta
	if dash_duration < 0.0:
		transition.emit(previous_state.name)
	
func physics_update(delta):
	tick += 1
	if tick % 3 == 0:
		spawn_ghost()
	actor.velocity.x = move_toward(actor.velocity.x, pivot.scale.x * actor.SPEED * 4, actor.ACCELERATION * delta * 4)	

	if actor.velocity.x != 0:
		pivot.scale.x = sign(actor.velocity.x)	
			
	actor.move_and_slide()

func spawn_ghost():
	var sprite = ghost_sprite_scene.instantiate()
	sprite.position = actor.sprite.global_position
	sprite.frame = actor.sprite.frame
	sprite.offset = actor.sprite.offset
	sprite.scale.x = pivot.scale.x
	ghost_spawned.emit(sprite)
