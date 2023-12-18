extends Projectile

signal explosion_spawned

var explosion_scene = preload("res://scenes/fireball_explosion.tscn")

func explode():
	var expl = explosion_scene.instantiate()
	expl.position = self.global_position
	explosion_spawned.emit(expl)
