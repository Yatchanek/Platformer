extends AnimatableBody2D
class_name Crusher

@export var height : int
@export var auto : bool
@export_enum("Forest", "Cave", "Grassland", "OakWood", "Castle") var environment = 0

@onready var body = $Body
@onready var head = $Body/Head
@onready var body_segment = $Body/BodySegment
@onready var collision_shape = $CollisionShape2D
@onready var attack_collision_shape : CollisionShape2D = $AttackBox/CollisionShape2D
@onready var player_detect_collision : CollisionShape2D = $PlayerDetector/CollisionShape2D
@onready var delay_timer : Timer = $DelayTimer

var current_damage : int = 999
var affinity : int = Globals.Affinities.NONE
var initial_pos : float

func _ready():
	head.region_rect.position.x = environment * 3 * Globals.TILE_SIZE
	body_segment.region_rect.position.x = environment * 3 * Globals.TILE_SIZE
	attack_collision_shape.set_deferred("disabled", true)
	initial_pos = position.y
	construct()
	if auto:
		delay_timer.wait_time = randf_range(0.75, 2.0)
		delay_timer.start()
		player_detect_collision.set_deferred("disabled", true)
	
func construct():
	for i in height - 1:
		var new_segment = body_segment.duplicate()
		new_segment.position.y = -Globals.TILE_SIZE * (2 + i)
		body.call_deferred("add_child", new_segment)
	collision_shape.shape.size.y = Globals.TILE_SIZE * height
	collision_shape.position.y = -Globals.TILE_SIZE * height * 0.5
	player_detect_collision.shape.size.y = Globals.TILE_SIZE * height
	player_detect_collision.position.y = Globals.TILE_SIZE * height * 0.5

func shake():
	$AnimationPlayer.play("Shake", -1, 1.25)

func crush():
	attack_collision_shape.set_deferred("disabled", false)
	player_detect_collision.set_deferred("disabled", true)
	var tw = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO).set_parallel()
	tw.finished.connect(_on_crush_finished)
	tw.step_finished.connect(_on_crush_step_finished)
	tw.tween_property(self, "position:y", initial_pos + height * Globals.TILE_SIZE, 0.1 * height)
	tw.chain().tween_interval(1.0)

func lift():
	var tw = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tw.finished.connect(_on_lift_finished)
	tw.tween_property(self, "position:y", initial_pos, 0.25 * height)

func _on_crush_step_finished(idx : int):
	if idx == 0:
		$GPUParticles2D.emitting = true
	
func _on_crush_finished():
	lift()
	attack_collision_shape.set_deferred("disabled", true)

func _on_lift_finished():
	if not auto:
		player_detect_collision.set_deferred("disabled", false)
	else:
		delay_timer.wait_time = randf_range(0.75, 2.0)
		delay_timer.start()	

func _on_animation_player_animation_finished(_anim_name):
	crush()


func _on_player_detector_body_entered(_body):
	if not auto:
		shake()


func _on_delay_timer_timeout():
	shake()
