extends Area2D

@onready var label = $Label

var activated : bool = false

var tw : Tween

signal checkpoint_reached(pos : Vector2)
signal player_nearby(area : Area2D)
signal player_left

func _ready():
	add_to_group("Interactables")
	add_to_group("Checkpoints")

func _on_body_entered(_body):
	player_nearby.emit(self)
	set_label_opacity(1.0)
	

func _on_body_exited(_body):
	player_left.emit()
	if not activated:
		set_label_opacity(0.0)
	
func interact():
	activated = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.region_rect.position.x = 23
	checkpoint_reached.emit(global_position)
	$Label.text = "Checkpoint activated!"

	get_tree().create_timer(2.0).timeout.connect(func() : set_label_opacity(0.0))
	


func set_label_opacity(value : float):
	if tw:
		tw.kill()

	tw = create_tween()
	tw.tween_property(label, "modulate:a", value, 0.2)	
