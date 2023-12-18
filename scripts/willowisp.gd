extends Node2D

@export var path_follow : PathFollow2D
@export var mode : Mode
@export var follow_target : Marker2D
@onready var light = $PointLight2D
@onready var sprite = $AnimatedSprite2D

var angle : float = 0.0
var is_moving : bool = false
var tick : int = 0
var next_offset : float = 0.0
var next_light_level : float = 1.5
var next_dimness_level : float = 0.0
var max_distance : float = 128.0 * 128.0
var base_energy_level : float

var state : MoveMode
var tw : Tween

enum Mode {
	GUIDE,
	FOLLOW,
	IDLE
}

enum MoveMode {
	ACTIVE,
	IDLE
}

func _ready():
	max_distance = $Area2D/CollisionShape2D.shape.radius * 1.15
	max_distance = pow(max_distance, 2)
	state = MoveMode.IDLE
	base_energy_level = 0.3

func move():
	
	if path_follow.progress_ratio >= 1.0:
		is_moving = false
		return
	is_moving = true
	next_offset = path_follow.progress_ratio + 0.1


func _physics_process(delta):
	if state == MoveMode.IDLE:
		return
	if mode == Mode.GUIDE:
		if not is_moving:
			angle = wrapf(angle + 3 * delta, 0, TAU)
			position.y = 4 * sin(angle)
		else:
			var ratio = global_position.distance_squared_to(Globals.player.global_position) / max_distance
			path_follow.progress_ratio = move_toward(path_follow.progress_ratio, 1.0, 0.15 * delta * (1 - ratio))
	elif follow_target:
		global_position = lerp(global_position, follow_target.global_position, 0.05)

func _process(_delta):
	tick = wrapi(tick + 1, 0, 100)
	if tick % 5 == 0:
		var offset = randf_range(-0.35, 0.0)
		next_light_level = base_energy_level + offset
		next_dimness_level = -offset
		
	light.energy = lerp(light.energy, next_light_level, 0.2)
	sprite.modulate = lerp(sprite.modulate, Color.WHITE.darkened(next_dimness_level), 0.2)
		
func move_ended():
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() > 0:
		move()
	else:
		is_moving = false

func brighten():
	if tw:
		tw.kill()
	tw = create_tween().set_parallel()
	tw.tween_property(self, "base_energy_level", 2.0, 1.0)
	tw.tween_property(light, "texture_scale", 1.25, 1.0)

func dim():
	if tw:
		tw.kill()
	tw = create_tween().set_parallel()
	tw.tween_property(self, "base_energy_level", 0.3, 1.0)
	tw.tween_property(light, "texture_scale", 0.5, 1.0)

func _on_area_2d_body_entered(body : Forresta):
		if mode == Mode.FOLLOW:
			if state == MoveMode.IDLE:
				follow_target = body.follow_point
				state = MoveMode.ACTIVE
				body.will_o_wisp_following = self
				brighten()
		else:
			move()

func _on_area_2d_body_exited(_body):
	if mode == Mode.GUIDE:
		move_ended()
	else:
		dim()
		
