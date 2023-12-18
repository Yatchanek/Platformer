extends Area2D

@onready var label = $Label
@onready var sprite = $Sprite2D

@export_multiline var description : String
@export var board_visible : bool = true

var tw : Tween

func _ready():
	sprite.visible = board_visible
	label.text = description
	label.position.x = -label.size.x * 0.5
	label.position.y = -22 - label.size.y - 16




func _on_body_entered(_body):
	if tw:
		tw.kill()
	
	tw = create_tween()
	tw.tween_property(label, "modulate:a", 1.0, 0.25)



func _on_body_exited(_body):
	if tw:
		tw.kill()
	
	tw = create_tween()
	tw.tween_property(label, "modulate:a", 0.0, 0.25)
