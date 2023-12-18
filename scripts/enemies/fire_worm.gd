extends BasicEnemy
class_name FireWorm

@export var turn_probability : float
@export var turn_interval : float

@onready var close_player_detector : RayCast2D = $Pivot/ClosePlayerDetector

var fireball_scene = preload("res://scenes/worm_fireball.tscn")

var has_been_attacked : bool = false

signal projectile_fired(fball : Area2D)

func spawn_fireball():
	if close_player_detector.is_colliding():
		return
	var fireball : Projectile = fireball_scene.instantiate()
	fireball.global_position = $Pivot/FireballSpawnPoint.global_position
	fireball.initialize(pivot.scale.x)
	projectile_fired.emit(fireball)


func _on_forget_timer_timeout():
	has_been_attacked = false
