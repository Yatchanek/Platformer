extends State

var horiz_turn_interval : float
var vert_turn_interval : float
var raycast_disable_duration : float = 1.0
var disabled_raycast : RayCast2D
var last_vert_collision : RayCast2D

func enter_state(_previous_state : State):
	animator.play("Fly", -1, 1.0)
	horiz_turn_interval = randf_range(5.0, 7.0)
	vert_turn_interval = randf_range(5.0, 7.0)
	actor.velocity = actor.speed * Vector2.RIGHT.rotated(randf_range(-PI / 24, PI / 24))
	
func frame_update(delta):
	horiz_turn_interval -= delta
	vert_turn_interval -= delta
	if disabled_raycast:
		raycast_disable_duration -= delta
		if raycast_disable_duration <= 0:
			disabled_raycast.enabled = true
			disabled_raycast = null
			
	if horiz_turn_interval <= 0:
		turn_horiz()
		horiz_turn_interval = randf_range(5.0, 7.0)
		
	if vert_turn_interval <=0:
		turn_vert()
		last_vert_collision = null
		vert_turn_interval = randf_range(5.0, 7.0)

func physics_update(delta):
	if actor.position.y > actor.max_down or actor.position.y < actor.max_up:
		turn_vert()
		vert_turn_interval = randf_range(5.0, 7.0)
		
	var colliding_raycast = get_vert_collision()
	if colliding_raycast != null:
		if not colliding_raycast == last_vert_collision:
			turn_vert()
			vert_turn_interval = randf_range(5.0, 7.0)
			last_vert_collision = colliding_raycast
#		disabled_raycast = colliding_raycast
#		disabled_raycast.enabled = false
#		raycast_disable_duration = 1.0
		
	if actor.position.x > actor.max_right or actor.position.x < actor.max_left \
	or actor.right.is_colliding():
		turn_horiz()
		horiz_turn_interval = randf_range(5.0, 7.0)
		
	actor.move_and_slide()

func get_vert_collision() -> RayCast2D:
	if actor.up.is_colliding():
		return actor.up
	elif actor.down.is_colliding():
		return actor.down
	return null
		
func turn_horiz():
	actor.velocity.x = -actor.velocity.x
	actor.velocity = actor.velocity.rotated(randf_range(-PI / 6, PI/ 6))
	actor.velocity = actor.velocity.normalized() * actor.speed
	if actor.velocity.x != 0:
		pivot.scale.x = sign(actor.velocity.x)
	else:
		pivot.scale.x = 1

func turn_vert():
	actor.velocity.y = -actor.velocity.y
	actor.velocity = actor.velocity.rotated(randf_range(-PI / 6, PI/ 6))
	actor.velocity = actor.velocity.normalized() * actor.speed
