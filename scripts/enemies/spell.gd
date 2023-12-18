extends Node2D

var damage : int = 3
var affinity : int = Globals.Affinities.NONE

func _ready():
	$AnimationPlayer.play("Spell", -1, 0.75)

func _on_animation_player_animation_finished(_anim_name):
	queue_free()
