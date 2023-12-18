extends Area2D

@export var key_type : Globals.KeyTypes

func _ready():
	$Sprite2D.region_rect.position.x = key_type * 12
	var tw = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property($Sprite2D, "offset:y", -8, 1.0)
	tw.tween_property($Sprite2D, "offset:y", -4, 1.0)



func _on_body_entered(body : Forresta):
	body.possessed_keys[key_type] += 1
	queue_free()
