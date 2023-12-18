extends GPUParticles2D

func _ready():
	emitting = true
	get_tree().create_timer(lifetime + 0.05).timeout.connect(queue_free)
