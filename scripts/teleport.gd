extends Area2D

@export var target : Marker2D
@export var is_level_end : bool = true
@export var level_node : Node2D

@export var active : bool = true

func _ready():
	if not active:
		hide()
		$CollisionShape2D.set_deferred("disabled", true)

func activate():
	show()
	$CollisionShape2D.set_deferred("disabled", false)

func _on_body_entered(_body : Forresta):
	if is_level_end:
		if not level_node:
			return
		EventBus.level_end_reached.emit(level_node)
	else:	
		var tw = create_tween()
		Globals.player.teleport(target)
		#tw.step_finished.connect(_on_tween_step_finished)
		tw.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.5)
		tw.tween_interval(3.0)
		tw.tween_property($AnimatedSprite2D, "scale", Vector2.ONE, 0.5)
