extends Node2D
class_name Level

var player_scene : PackedScene

@onready var player_spawn_spot : Marker2D = $PlayerSpawnSpot

@export var exit_up : bool
@export var exit_right : bool
@export var exit_down : bool
@export var exit_left : bool
@export var max_tombstones : int = 10

var tombstones : Array = []

var tw : Tween
var player : CharacterBody2D

var interactable_in_range : Area2D

var pickable_scene : PackedScene = preload("res://scenes/pickable.tscn")
var tomb_texture = preload("res://graphics/environment/tombstone.png")

signal game_over

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_E:
			if !interactable_in_range:
				return
			interactable_in_range.interact()
			
func _ready():
	player = player_scene.instantiate()
	player.global_position = player_spawn_spot.global_position
	add_child(player)
	connect_signals()

	SceneChanger.fade_in()

	
func create_tombstone(location : Vector2):
	if tombstones.size() == max_tombstones:
		var tomb = tombstones.pop_front()
		tomb.queue_free()
	var sprite = Sprite2D.new()
	sprite.texture = tomb_texture
	sprite.offset.y = -12
	sprite.global_position = location
	sprite.z_index = -2
	tombstones.append(sprite)
	call_deferred("add_child", sprite)
	
		
func connect_signals():		
	for interactable in get_tree().get_nodes_in_group("Interactables"):
		if interactable.has_signal("player_nearby"):
			interactable.player_nearby.connect(_on_player_near_interactable)
		if interactable.has_signal("player_left"):
			interactable.player_left.connect(_on_player_left_interactable)
	for entrance in get_tree().get_nodes_in_group("CaveEntrances"):
		entrance.cave_entered.connect(cave_entered)
		entrance.cave_exited.connect(cave_exited)
	for checkpoint in get_tree().get_nodes_in_group("Checkpoints"):
		checkpoint.checkpoint_reached.connect(_on_checkpoint_reached)

	player.ghost_spawned.connect(_on_ghost_spawned)
	player.fireball_spawned.connect(_on_projectile_spawned)
	player.died.connect(_on_player_died)
	player.teleport_ended.connect(_on_player_teleported)
	player.soul_released.connect(_on_player_soul_released)	
	player.effect_spawned.connect(_on_entity_spawned)

func _on_enemy_spawned(enemy : CharacterBody2D):
	if enemy.has_signal("projectile_fired"):
		enemy.projectile_fired.connect(_on_projectile_spawned)
	if enemy.has_signal("died"):
		enemy.died.connect(_on_monster_died)
	if enemy is NightBorne:
		enemy.tilemap = $TileMap

func _on_pickable_dropped(item : Globals.Pickups):
	var drop_position = player.global_position + Vector2(player.pivot.scale.x * 16, -8)
	var pickable : Pickable = pickable_scene.instantiate() as Pickable
	pickable.type = item
	pickable.position = drop_position
	call_deferred("add_child", pickable)
		
func _on_player_died(place_tombstone : bool = true):

	await get_tree().create_timer(1.0).timeout
	SceneChanger.fade_out()
	await get_tree().create_timer(1.0).timeout
	if place_tombstone:
		create_tombstone(player.global_position)
	player.global_position = player_spawn_spot.global_position
	player.reset()
	await get_tree().create_timer(1.0).timeout
	SceneChanger.fade_in()

func _on_entity_spawned(entity : Node2D):
	add_child(entity)

func _on_ghost_spawned(ghost : Sprite2D):
	call_deferred("add_child", ghost)

func _on_projectile_spawned(projectile : Node2D):
	if projectile.has_signal("explosion_spawned"):
		projectile.explosion_spawned.connect(_on_spawn_fireball_explosion)
	call_deferred("add_child", projectile)
	
func _on_spawn_fireball_explosion(explosion : AnimatedSprite2D):
	call_deferred("add_child", explosion)
	
func _on_player_near_interactable(interactable: Area2D):
	interactable_in_range = interactable
	
func _on_player_left_interactable():
	interactable_in_range = null

func _on_monster_died(monster : BasicEnemy):
	if monster.is_boss:
		monster.teleport_guarded.activate()
	monster.queue_free()


func _on_player_teleported():
	if tw:
		tw.kill()
	tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tw.tween_property($CanvasModulate, "color", Color(1.0, 1.0, 1.0), 0.25)
	
func _on_player_soul_released(soul : Sprite2D):
	soul.tree_exited.connect(_on_player_died.bind(false))
	call_deferred("add_child", soul)


func _on_bottom_border_body_entered(_body):
	_on_player_died(false)


func _on_checkpoint_reached(_pos : Vector2):
	player_spawn_spot.global_position = _pos

func cave_entered(max_depth : int):
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property($CanvasModulate, "color", Color(0.1, 0.1, 0.1, 1), 0.5)
	$TileMap.set_layer_enabled(3, false)
	for light in get_tree().get_nodes_in_group("Lights"):
		light.activate()
	move_bottom_border(-max_depth - 128)
	Globals.player.camera.limit_bottom = max_depth
	
func cave_exited():
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property($CanvasModulate, "color", Color.WHITE, 0.5)
	$TileMap.set_layer_enabled(3, true)
	for light in get_tree().get_nodes_in_group("Lights"):
		light.deactivate()
	move_bottom_border(-512)
	Globals.player.camera.limit_bottom = 999
	
func move_bottom_border(dist : int):
	$BottomBorder/CollisionShape2D.shape.distance = dist
		
func _on_tree_entered():
	EventBus.enemy_spawned.connect(_on_enemy_spawned)
