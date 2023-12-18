extends AnimatedSprite2D


@onready var light_source = $LightSource

var tw : Tween
var tick : int = 0
var next_light_level : float
var base_energy_level : float = 1.25
var next_dimness_level : float

func _ready():
	add_to_group("Lights")
	set_process(false)

func _process(delta):
	tick = wrapi(tick + 1, 0, 100)
	if tick % 5 == 0:
		var offset = randf_range(-0.35, 0.0)
		next_light_level = base_energy_level + offset
		next_dimness_level = -offset
		
	light_source.energy = lerp(light_source.energy, next_light_level, 0.2)
	self_modulate = lerp(self_modulate, Color.WHITE.darkened(next_dimness_level), 0.2)


func activate():
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property(light_source, "energy", 1.25, 0.15)
	set_process(true)
	
func deactivate():
	if tw:
		tw.kill()
	tw = create_tween()
	tw.tween_property(light_source, "energy", 0.0, 0.15)
	set_process(false)
