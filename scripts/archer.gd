extends BasicEnemy

var arrow_scene = preload("res://scenes/arrow.tscn")
var is_running_away : bool = false

@onready var eyes = $Pivot/Eyes
@onready var back_wall_detector = $Pivot/BackWallDetector
@onready var back_gap_detector = $Pivot/BackGapDetector

signal projectile_fired(projectile)

func fire_arrow():
	var arrow = arrow_scene.instantiate()
	arrow.global_position = $Pivot/ArrowSpawnPosition.global_position
	arrow.affinity = affinity
	arrow.initialize(pivot.scale.x)
	projectile_fired.emit(arrow)

func can_see_player():
	for raycast in eyes.get_children():
		if raycast.is_colliding() and raycast.get_collider() is Forresta:
			return true
	return false
