extends Node

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func fade_in():
	animation_player.play_backwards("FadeOut")
	await animation_player.animation_finished
	if is_instance_valid(Globals.player) and Globals.player.frozen:
		Globals.player.activate()
	
func fade_out():
	animation_player.play("FadeOut")


func change_scene(target_scene : String):
	fade_out()
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene)
	await get_tree().create_timer(1.0).timeout
	fade_in()
	
