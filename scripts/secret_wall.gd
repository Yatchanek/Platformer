extends Node2D

@export var tilemap : TileMap
@export var width : int
@export var height : int
@export var target_layer : int
@export var initial_pos : Vector2i

var initial_modulate : float = 1.0

func _ready():
	set_process(false)

func _process(delta):
	initial_modulate -= delta
	tilemap.set_layer_modulate(target_layer, Color(1, 1, 1, initial_modulate))

	if initial_modulate <= 0:
		set_process(false)
		delete_cells()
	
func open():
	set_process(true)

func delete_cells():
	if not initial_pos:
		initial_pos = tilemap.local_to_map(tilemap.to_local(global_position))
	for x in width:
		for y in height:
			tilemap.erase_cell(target_layer, initial_pos + Vector2i(x, y))
	tilemap.set_layer_modulate(target_layer, Color.WHITE)
	queue_free()

func _on_lever_activated():
	open()
	
func _on_lever_deactivated():
	pass
