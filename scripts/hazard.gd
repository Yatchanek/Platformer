extends Area2D
class_name Hazard

@export var size : Vector2i
@export var current_damage : float
@export var affinity : Globals.Affinities = Globals.Affinities.NONE
@export_range(0.05, 5.0, 0.05) var hurt_interval : float = 1.0
@export var align : Alignment
@export var effect_height : float = 1.0
@export var is_lava_or_water : bool = false


@onready var interval_timer : Timer = $IntervalTimer
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var particles : GPUParticles2D = $GPUParticles2D

enum Alignment {
	HORIZONTAL_TOP,
	HORIZONTAL_BOTTOM,
	VERTICAL_LEFT,
	VERTICAL_RIGHT
}



var target : CharacterBody2D

func _ready():
	particles.lifetime = effect_height * 0.5
	particles.amount = 8 * size.x * effect_height * 0.5
	particles.process_material.color_ramp = load(Globals.affinity_gradients[affinity])
	
	match align:
		Alignment.HORIZONTAL_TOP:
			collision_shape.shape.size.x = size.x * 16
			collision_shape.shape.size.y = size.y * 16 - 8
			collision_shape.position.x = size.x * 8
			collision_shape.position.y = size.y * 8 - 4
			particles.position = Vector2(size.x * 8, size.y * 4 - 4)
			#particles.process_material.emission_box_extents = Vector3(16 * size.x / 2, 1, 1)
			particles.process_material.gravity = Vector3(0, 48, 0)
		Alignment.HORIZONTAL_BOTTOM:
			collision_shape.shape.size.x = size.x * 16
			collision_shape.shape.size.y = size.y * 16 - 8
			collision_shape.position.x = size.x * 8
			collision_shape.position.y = size.y * 8 + 4
			particles.position = Vector2(size.x * 8, size.y * 4 + 4)
		#	particles.process_material.emission_box_extents = Vector3(16 * size.x / 2, 1, 1)
			particles.process_material.gravity = Vector3(0, -48, 0)
		Alignment.VERTICAL_LEFT:
			collision_shape.shape.size.x = size.x * 16 - 8
			collision_shape.shape.size.y = size.y * 16
			collision_shape.position.x = size.x * 8 - 4
			collision_shape.position.y = size.y * 8
			particles.position = collision_shape.position + Vector2.LEFT * 4
			particles.process_material.emission_box_extents = Vector3(1, 16 * size.y / 2, 1)
			particles.process_material.gravity = Vector3(48, 0, 0)
		Alignment.VERTICAL_RIGHT:
			collision_shape.shape.size.x = size.x * 16 - 8
			collision_shape.shape.size.y = size.y * 16
			collision_shape.position.x = size.x * 8 + 4
			collision_shape.position.y = size.y * 8
			particles.position = collision_shape.position + Vector2.RIGHT * 4
			particles.process_material.emission_box_extents = Vector3(1, 16 * size.y / 2, 1)
			particles.process_material.gravity = Vector3(-48, 0, 0)
	particles.process_material.emission_box_extents = Vector3(size.x * 8, size.y * 4, 1)
	interval_timer.wait_time = hurt_interval
	if affinity != Globals.Affinities.NONE:
		particles.emitting = true
		
func _on_body_entered(body):
	target = body
	target.take_damage(self)
	interval_timer.start()
	if is_lava_or_water:
		body.drown()


func _on_interval_timer_timeout():
	if get_overlapping_bodies().size() > 0:
		if target.is_dead:
			return
		target.take_damage(self)
		interval_timer.start()
	else:
		target = null
