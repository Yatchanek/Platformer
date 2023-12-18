extends Sprite2D

var lifetime : float = 5.0
const ACCELERATION = 32.0
var velocity : float = 0
var wobble : float = 16
var angle : float = 0
var initial_x : float

func _ready():
	initial_x = global_position.x
	set_process(false)
	var tw = create_tween().set_ease(Tween.EASE_IN_OUT)
	tw.finished.connect(_on_tween_finished)	
	tw.tween_interval(1.0)
	tw.tween_property(self, "modulate:a", 0.5, 0.5)
	
func _process(delta):
	lifetime -= 1.25 * delta
	modulate.a -= 0.125 * delta
	if lifetime <= 0:
		queue_free()
	velocity -= ACCELERATION * delta
	global_position.y += velocity * delta
	global_position.x = initial_x + wobble * sin(angle)
	angle += delta

func _on_tween_finished():
	set_process(true)
