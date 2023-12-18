extends Node2D

var wobble_count : int = 0


func wobble():
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tw.finished.connect(wobble_round_finished)
	tw.set_parallel()
	tw.tween_property($LeftPlank, "rotation", randf_range(-PI / 32, PI / 32), 0.05)
	tw.tween_property($RightPlank, "rotation", randf_range(-PI / 32, PI / 32), 0.05)	

func activate():
	$LeftPlank/CollisionShape2D.set_deferred("disabled", true)
	$RightPlank/CollisionShape2D.set_deferred("disabled", true)
	$Detector/CollisionShape2D.set_deferred("disabled", true)
	var tw = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tw.set_parallel()
	tw.tween_property($LeftPlank, "rotation", PI * 0.5, 0.5)
	tw.tween_property($RightPlank, "rotation", -PI * 0.5, 0.5)

func wobble_round_finished():
	wobble_count += 1
	if wobble_count < 15:
		wobble()
	else:
		activate()


func _on_detector_body_entered(_body):
	wobble()
