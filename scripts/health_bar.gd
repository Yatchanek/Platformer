extends TextureProgressBar
class_name HealthBar

func _ready():
	self.hide()

func update_bar(_value : float):
	value = _value
	if _value < 1.0:
		self.show()
	tint_progress = Color.GREEN
	if _value < 0.33:
		tint_progress = Color.RED
	elif _value < 0.66:
		tint_progress = Color.YELLOW
