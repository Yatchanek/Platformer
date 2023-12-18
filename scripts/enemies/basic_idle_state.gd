extends State
class_name EnemyIdleState

func enter_state(_prev_state : State):
	animator.play("Idle", -1, actor.idle_anim_speed)
	actor.velocity = Vector2.ZERO

