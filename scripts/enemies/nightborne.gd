extends BasicEnemy
class_name NightBorne

@export var teleport_spots : Array[Marker2D] 
@onready var eyes : Marker2D = $Pivot/Eyes
@onready var hurtbox_collision = $Pivot/Hurtbox/CollisionShape2D

var teleport_spot : Marker2D
var eyes_pos : Vector2
var is_running_away : bool = false
var teleport_cooldown : float = 5.0
var target_lost : bool = true

var tilemap : TileMap

func _ready():
	super()
	eyes_pos = global_position + Vector2.UP * 25
	
func can_see_player():
	for vision_ray in eyes.get_children():
		if vision_ray.is_colliding():
			if vision_ray.get_collider().name == "Forresta":
				target_lost = false
				return true
	target_lost = true
	return false

func _on_basic_die_state_died():
	queue_free()
