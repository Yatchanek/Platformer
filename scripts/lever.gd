extends Area2D

@export var is_activated : bool = false:
	set(value):
		if value : 
			$Sprite2D.region_rect.position.x = 16
		else : 
			$Sprite2D.region_rect.position.x = 0
		is_activated = value
@export var two_way : bool = false
@export var targets : Array[Node2D]
@export var action_activate : String
@export var action_deactivate : String
@export var requires_key : bool = false
@export var key_required : Globals.Pickups
@export var level_node : Node2D

signal player_nearby(lever : Area2D)
signal player_left
signal activated(targets : Array, action : String)
signal deactivated(targets : Array, action : String)

func _ready():
	add_to_group("Interactables")
	
	if is_activated:
		$Sprite2D.region_rect.position.x = 16
	
	for target in targets:
		activated.connect(target._on_lever_activated)
		deactivated.connect(target._on_lever_deactivated)

func interact():
	if requires_key and not Globals.player.check_for_key(key_required):
		return
	if not is_activated:
		is_activated = true
		activated.emit()
		requires_key = false
		if not two_way:
			$CollisionShape2D.set_deferred("disabled", true)
			player_left.emit()
		if requires_key:
			Globals.player.inventory.use_item(key_required)
			return
	if two_way and action_deactivate != null:
		is_activated = false
		deactivated.emit()
	
func _on_body_entered(body : Forresta):
	player_nearby.emit(self)
	if requires_key and not body.check_for_key(key_required):
		$Label.text = "%s required" % Globals.key_names[key_required]
		$Label.show()

func _on_body_exited(_body):
	player_left.emit()
	$Label.hide()
