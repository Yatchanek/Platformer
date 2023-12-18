extends Area2D

@export var target : Node2D
@export var mode : Mode

enum Mode {
	ACTIVATE,
	DEACTIVATE
}

func _on_body_entered(body):
	if mode == Mode.ACTIVATE:
		target.activate()
	else:
		target.deactivate()
