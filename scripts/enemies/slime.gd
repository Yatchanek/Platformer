extends BasicEnemy
class_name Slime

var h_value : float
var sprite_material
var target : CharacterBody2D

func _ready():
	super()
	sprite.modulate = Globals.affinity_colors[affinity]


func take_damage(attacker):
	super(attacker)
	target = Globals.player


func check_for_edges():
	if not gap_detector.is_colliding() or wall_detector.is_colliding():
		pivot.scale.x *= -1
		if target:
			target = null

func check_for_player():
	if target:
		var distance_x = global_position.distance_to(target.global_position)
		if distance_x > 128:
			target = null
			return
		elif distance_x > 24:
			turn_to_player()

