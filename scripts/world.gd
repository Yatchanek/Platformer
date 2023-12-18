extends Node2D

@export var levels : Array[String]

var player_scene = preload("res://scenes/forresta_2.tscn")

var tombstone_locations : Array[Vector2] = []

var current_level : int = 0
var next_level_path : String

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()

		elif event.is_pressed() and event.keycode == KEY_I:
			$HUD/Control/Inventory.visible = !$HUD/Control/Inventory.visible
		
		elif event.is_pressed() and event.keycode == KEY_D:
			$HUD/Control/StatusWindow.visible = !$HUD/Control/StatusWindow.visible

func _ready():
	if not is_level_loaded():
		ResourceLoader.load_threaded_request(levels[current_level])
		var new_level : Level = ResourceLoader.load_threaded_get(levels[current_level]).instantiate()
		new_level.game_over.connect(_on_level_game_over)
		new_level.player_scene = player_scene
		call_deferred("add_child", new_level)
	else:
		var level = get_level()
		level.player_scene = player_scene
		
	$DeathEffect.emitting = true
	EventBus.level_end_reached.connect(_on_level_end_reached)


func get_level() -> Level:
	for child in get_children():
		if child is Level:
			return child
	return null

func is_level_loaded() -> bool:
	for child in get_children():
		if child is Level:
			return true
	return false

func _on_level_game_over(_level : Node2D):
	pass

func _on_level_end_reached(level : Node2D):
	cache_new_level()
	Globals.tombstone_locations = []
	Globals.player_data = Globals.player.Stats
	Globals.player_inventory = Globals.player.inventory
	current_level = wrapi(current_level + 1, 0, 2)
	SceneChanger.fade_out()
	await get_tree().create_timer(1.25).timeout
	level.queue_free()
	var new_level : Level = ResourceLoader.load_threaded_get(next_level_path).instantiate()
	new_level.game_over.connect(_on_level_game_over)
	call_deferred("add_child", new_level)
	new_level.player_scene = player_scene
	#SceneChanger.fade_in()	

func cache_new_level():
	var next_level : int = wrapi(current_level + 1, 0, 2)
	next_level_path = levels[next_level]
	ResourceLoader.load_threaded_request(next_level_path)
