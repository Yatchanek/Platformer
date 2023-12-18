extends Sprite2D

func _process(delta):
	modulate.a -= 10 * delta
	if modulate.a <= 0:
		queue_free()
