extends Projectile
class_name Fireball

var explosion_scene = preload("res://scenes/fireball_explosion.tscn")

signal explosion_spawned(explosion : AnimatedSprite2D)

		
func explode():
	var expl = explosion_scene.instantiate()
	expl.position = self.global_position
	explosion_spawned.emit(expl)
