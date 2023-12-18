extends Node2D
class_name Ladder

@export var size : int
@onready var upper_collision := $UpperBlock/CollisionShape2D
@onready var body_collision = $LadderBody/CollisionShape2D

var is_on_top : bool = false

func _ready():
	body_collision.shape.size.y = 16 * (size - 1) - 8
	body_collision.position.y = 24 + 0.5 * body_collision.shape.size.y

func open():
	$UpperBlock.collision_layer = 128
	
func close():
	$UpperBlock.collision_layer = 129

func _on_ladder_body_body_entered(body):
	body.can_climb = true
	body.current_ladder = self
	if not is_on_top:
		open()

func _on_ladder_body_body_exited(body):
	body.can_climb = false
	body.current_ladder = null
	if is_on_top:
		body.global_position.y -= 24
		close()
		

func _on_upper_check_body_entered(body):
	is_on_top = true
	body.current_ladder = self
	body.on_top_of_ladder = self

func _on_upper_check_body_exited(body):
	is_on_top = false
	body.on_top_of_ladder = null
	body.current_ladder = null
	if not body.global_position.y > global_position.y:
		body.can_climb = false
		close()



