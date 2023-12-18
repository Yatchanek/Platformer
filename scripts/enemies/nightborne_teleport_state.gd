extends State
class_name NightBorneTeleportState

var teleport_delay : float = 0.25
var teleport_started : bool = false

func enter_state(_previous_state : State):
	previous_state = _previous_state
	teleport_started = false
	teleport_delay = 0.25
	actor.health_bar.hide()
	actor.teleport_spots.sort_custom(sort_by_distance)
	actor.velocity.x = 0 
	find_destination()
	
func find_destination():
	if previous_state is NightBorneChaseState or previous_state is EnemyAttackState:
		var found_position : bool = false
		var offset : int
		if actor.global_position.x > Globals.player.global_position.x:
			offset = -1
		else:
			offset = 1
		var attempts : int = 0
		var gap_size : int = 4
		while not found_position:
			var target_pos : Vector2 = actor.global_position + Vector2(Globals.TILE_SIZE * gap_size * offset, 0)	
			var state = actor.get_world_2d().direct_space_state
			var query_1 = PhysicsRayQueryParameters2D.create(target_pos + Vector2(0, -5), target_pos + Vector2(0, 16), 1)
			var tile_pos : Vector2i = actor.tilemap.local_to_map(actor.tilemap.to_local(target_pos + Vector2(0, -18)))
			var tile_id = actor.tilemap.get_cell_source_id(0, tile_pos)
			if tile_id != -1:
					attempts += 1
					if attempts > 10:
						find_closest_spot()
						break
					gap_size -= 1
					if gap_size == 1:
						gap_size = 4
						offset *= -1
					continue
			var collision = state.intersect_ray(query_1)
			collision = state.intersect_ray(query_1)	
			if collision:
				actor.teleport_spots[0].global_position = target_pos
				actor.teleport_spot = actor.teleport_spots[0]
				found_position = true
			else:
				attempts += 1
				if attempts > 10:
					find_closest_spot()
					break
				gap_size += 1
				if gap_size > 8:
					gap_size = 4
					offset *= -1

	else:
		actor.teleport_spot = actor.teleport_spots[actor.teleport_spots.size() - 1]
		actor.health_bar.hide()


func frame_update(delta):
	if not teleport_started:
		teleport_delay -= delta
		if teleport_delay <= 0:
			teleport_started = true
			actor.hurtbox_collision.set_deferred("disabled", true)
			animator.play("Teleport", -1, 2.0)
	
func teleport():
	await get_tree().create_timer(0.25).timeout
	actor.global_position = actor.teleport_spot.global_position
	actor.sprite.show()
	animator.play("Teleport", -1, -2.0, true)

func find_closest_spot():
	var min_y_dist : float = INF
	for spot in actor.teleport_spots:
		var y_dist : float = abs(spot.global_position.y - Globals.player.position.y)
		if y_dist < min_y_dist:
			min_y_dist = y_dist
			actor.teleport_spot = spot

func animation_finished():
	if actor.sprite.frame > 110:
		actor.sprite.hide()
		teleport()
	else:
		actor.turn_to_player()
		if actor.hp < actor.max_hp:
			actor.health_bar.show()
		actor.hurtbox_collision.set_deferred("disabled", false)
		transition.emit("IdleState")

func sort_by_distance(a, b):
	return a.global_position.distance_to(Globals.player.global_position) < b.global_position.distance_to(Globals.player.global_position)
