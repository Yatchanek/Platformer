extends Area2D
class_name CaveEntrance

@export var direction : Location
@export var size : int
@export var max_depth : int

enum Location {
	UP,
	RIGHT,
	BOTTOM,
	LEFT
}

signal cave_entered
signal cave_exited

func _ready():
	add_to_group("CaveEntrances")
	if direction == Location.RIGHT or direction == Location.LEFT:
		$CollisionShape2D.shape.size.x = Globals.TILE_SIZE
		$CollisionShape2D.shape.size.y = size * Globals.TILE_SIZE
		$CollisionShape2D.position.y = 0.5 * size * Globals.TILE_SIZE
		$CollisionShape2D.position.x = 0
	else:
		$CollisionShape2D.shape.size.y = Globals.TILE_SIZE
		$CollisionShape2D.shape.size.x = size * Globals.TILE_SIZE
		$CollisionShape2D.position.x = 0.5 * size * Globals.TILE_SIZE
		$CollisionShape2D.position.y = 0

func _on_body_exited(body : Forresta):
	if direction == Location.LEFT:
		if body.global_position.x > global_position.x:
			cave_entered.emit(max_depth)
			
		else:
			cave_exited.emit()

	elif direction == Location.RIGHT:
		if body.global_position.x < global_position.x:
			cave_entered.emit(max_depth)
			
		else:
			cave_exited.emit()

	elif direction == Location.UP:
		if body.global_position.y > global_position.y:
			cave_entered.emit(max_depth)
		else:
			cave_exited.emit()

	else:
		if body.global_position.y < global_position.y:
			cave_entered.emit(max_depth)
		else:
			cave_exited.emit()

