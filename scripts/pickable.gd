extends Area2D
class_name Pickable

@onready var ground_detector : RayCast2D = $GroundDetector
@onready var sprite = $Sprite2D

var velocity : Vector2
var pop_direction : int = 1
var initial_y : float
@export var type : Globals.Pickups
@export var in_chest : bool = false

signal picked_up

func _ready():
	sprite.frame = type
	velocity = Vector2.ZERO
	if in_chest:
		velocity = Vector2(pop_direction * 0.2, -1) * 192
	
func _physics_process(delta):
	velocity.y += Globals.gravity * delta
	position += velocity * delta
	
	if ground_detector.is_colliding():
		velocity = Vector2.ZERO
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", false)
		initial_y = position.y
		animate()

func animate():
	var tw = create_tween().set_loops().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(sprite, "position:y", -4.0, 1.0)
	tw.tween_property(sprite, "position:y", 0.0, 1.0)

func _on_body_entered(body):
	var picked = body.pick_up(type)
	if picked:
		queue_free()

