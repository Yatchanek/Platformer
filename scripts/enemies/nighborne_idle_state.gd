extends EnemyIdleState
class_name NightBorneIdleState

var teleport_interval : float = 5.0
var turn_interval : float = randf_range(1.5, 2.0)
var eyes_pos : Vector2
var can_teleport : bool = false

func enter_state(_previous_state : State):
	super(_previous_state)
	turn_interval = randf_range(3.0, 5.0)
	
func frame_update(delta):
	turn_interval -= delta
	if turn_interval < 0:
		turn_interval = randf_range(1.5, 2.0)
		pivot.scale.x *= -1


func physics_update(delta):
	actor.velocity.y += actor.gravity * delta
	if actor.player_detector.is_colliding() and actor.can_attack:
		transition.emit("AttackState")
	elif actor.can_see_player():
		transition.emit("ChaseState")
	actor.move_and_slide()



