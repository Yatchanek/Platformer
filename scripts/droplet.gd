extends Area2D

@export var current_damage : int = 1
@export var affinity : Globals.Affinities

var _gravity = Globals.gravity
var acc : float = 0.0


func _ready():
	$AnimatedSprite2D.modulate = Globals.affinity_colors[affinity]
	set_physics_process(false)	

func _physics_process(delta):
	acc += _gravity * delta
	position.y += acc * delta

func _on_animated_sprite_2d_animation_finished():
	$AttackBox.activate()
	$CollisionShape2D.set_deferred("disabled", false)
	set_physics_process(true)

func _on_body_entered(_body):
	queue_free()


func _on_attack_box_area_entered(_area):
	queue_free()
