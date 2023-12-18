extends Node2D

@onready var spawn_timer = $SpawnTimer
@export var width : int
@export var affinity : Globals.Affinities = Globals.Affinities.NONE

@export_range(0.1, 3.0, 0.1) var min_interval : float
@export_range(0.2, 3.0, 0.1) var max_interval : float

@export var active : bool

var droplet_scene = preload("res://scenes/droplet.tscn")

func _ready():
	if active:
		set_timer()
		spawn_timer.start()
	
func set_timer():
	if not min_interval or not max_interval:
		spawn_timer.wait_time = randf_range(1.0, 2.0)
	else:
		spawn_timer.wait_time = randf_range(min_interval, max_interval)

func activate():
	set_timer()
	spawn_timer.start()
	
func deactivate():
	spawn_timer.stop()

func _on_spawn_timer_timeout():
	var droplet = droplet_scene.instantiate()
	droplet.position.x = randf_range(0, width * Globals.TILE_SIZE)
	droplet.affinity = affinity
	call_deferred("add_child", droplet)
	set_timer()
	spawn_timer.start()
