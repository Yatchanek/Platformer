extends TextureProgressBar

@export var change_colors : bool = false
@export var use_tween : bool = true

@export_color_no_alpha var safe_color
@export_color_no_alpha var mid_color
@export_color_no_alpha var danger_color

@onready var main_bar : TextureProgressBar = $MainProgress

func update_value(_value : float):
	main_bar.value = _value
	if use_tween:
		var tw = create_tween().set_ease(Tween.EASE_IN_OUT)
		tw.tween_property(self, "value", _value, 0.15)
	else:
		value = 0
	if change_colors:
		main_bar.tint_progress = safe_color
		if _value < 33:
			main_bar.tint_progress = danger_color
		elif _value < 66:
			main_bar.tint_progress = mid_color
