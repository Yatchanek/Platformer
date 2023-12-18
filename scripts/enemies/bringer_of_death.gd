extends BasicEnemy

var spell_scene = preload("res://scenes/spell.tscn")

@onready var cast_spell_timer = $CastSpellTimer
@onready var hurt_timer = $HurtTimer
@onready var eyes = $Pivot/Eyes
@onready var back_gap_detector = $Pivot/BackGapDetector
@onready var back_wall_detector = $Pivot/BackWallDetector
@onready var target_lost_timer : Timer = $TargetLostTimer

@export var patrol_speed : int
@export var chase_speed : int
@export var flee_speed : int


signal projectile_fired(projectile : Node2D)

var can_cast_spell : bool = true
var target : Forresta = null
var target_lost : bool = false
var player_too_close : bool = false

var hits_landed : int = 0

func _on_cast_spell_timer_timeout():
	can_cast_spell = true

func can_see_player() -> bool:
	for raycast in eyes.get_children():
		if raycast.is_colliding() and raycast.get_collider() is Forresta:
			return true
	return false

func cast_spell():
	if not target:
		return
	var spell = spell_scene.instantiate()
	spell.global_position = target.global_position
	projectile_fired.emit(spell)


func _on_hurt_timer_timeout():
	hits_landed = 0


func _on_target_lost_timer_timeout():
	target = null
	state_machine.transition("PatrolState")
	

func _on_proximity_alert_body_entered(_body):
	player_too_close = true
	

func _on_proximity_alert_body_exited(_body):
	player_too_close = false
