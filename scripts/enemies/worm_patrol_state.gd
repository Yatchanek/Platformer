extends BasicPatrolState
class_name WormPatrolState

func frame_update(delta):
	actor.turn_interval -= delta
	if not actor.has_been_attacked and actor.turn_interval < 0 and randf() < 0.25:
		pivot.scale.x *= -1
		actor.turn_interval = randf_range(3.0, 4.0)
	if not actor.player_detector.is_colliding and actor.has_been_attacked:
		actor.turn_to_player()
