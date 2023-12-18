extends Control

@onready var text_label = $TextLabel
var angle : float = 0
var initial_position_x : float
var text_to_display : String

func _ready():
	var tw = create_tween().set_parallel()
	tw.finished.connect(_on_tween_finished)
	#tw.tween_property(text_label, "label_settings:font_size", 32, 0.5)
	#tw.tween_property(self, "position:y", position.y - 32, 0.75)
	tw.tween_property(self, "modulate:a", 0.0, 1.0)
	initial_position_x = global_position.x
	text_label.text = text_to_display
	
func initialize(text : String):
	text_to_display = text
	
func _process(delta):
	global_position.y -= 16 * delta
	global_position.x = initial_position_x + 8 * sin(angle)
	angle +=  3 * delta


func _on_tween_finished():
	queue_free()
