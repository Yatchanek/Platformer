@tool
extends Node2D
class_name Platform

@export var tile_type : TileType
@export var tile_texture : Texture2D
@export var width : int
@export var move_range_horiz : int
@export var move_range_vert : int
@export var speed : int
@export var interval : float
@export var switchable : bool = false
@onready var platform_body = $PlatformBody

@onready var collision_shape : CollisionShape2D = $PlatformBody/CollisionShape2D


const TILE_SIZE : int = 16

enum TileType {
	GRASS,
	STONE,
}

var tween : Tween

func _ready():
	if not width:
		width = 4
	collision_shape.shape.size.x = width * TILE_SIZE - 6
	collision_shape.shape.size.y = 2 * TILE_SIZE - 8
	collision_shape.position.x = width * TILE_SIZE * 0.5
	collision_shape.position.y = TILE_SIZE - 4
	
	for i in width:
		create_sprite(i)
	
	if not switchable:
		animate()
	
func animate():
	var initial_position : Vector2 = global_position
	var offset_vector : Vector2
	offset_vector = Vector2(move_range_horiz * TILE_SIZE, -move_range_vert * TILE_SIZE)
	if tween:
		tween.kill()
	tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(platform_body, "global_position", initial_position + offset_vector, offset_vector.length() / speed / TILE_SIZE)
	tween.tween_interval(interval)
	tween.tween_property(platform_body, "global_position", initial_position, offset_vector.length() / speed / TILE_SIZE)
	tween.tween_interval(interval)

func stop():
	tween.kill()
	
func create_sprite(idx : int):
	var sprite = Sprite2D.new()
	sprite.centered = false
	sprite.region_enabled = true
	sprite.position = Vector2(TILE_SIZE * idx, 0)
	sprite.region_rect.size = Vector2(TILE_SIZE, 2 * TILE_SIZE)
	if idx != 0 and idx != width - 1:
		idx = 1
	elif idx == width - 1:
		idx = 2
	sprite.region_rect.position = Vector2(TILE_SIZE * idx, 2 * TILE_SIZE * tile_type)

	sprite.texture = tile_texture
	platform_body.call_deferred("add_child", sprite)

func _on_lever_activated():
	animate()

func _on_lever_deactivated():
	stop()
