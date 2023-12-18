extends TextureRect
class_name InventorySlot

@onready var item_texture = $ItemTexture
@onready var label = $Label
@export var small : bool = false
@export var is_trash_bin : bool = false

var item_name : String
var item_description : String
var item : int

var dust_emitter : GPUParticles2D

signal drag_started(data, slot)
signal drop_succesful
signal item_disposed(_item)

func _ready():
	if is_trash_bin:
		dust_emitter = load("res://scenes/item_dust.tscn").instantiate()
		call_deferred("add_child", dust_emitter)
		dust_emitter.set_deferred("position", get_rect().size * 0.5)

func insert_item(_item : Globals.Pickups, amount : int):
	if is_trash_bin:
		return
	item = _item
	item_texture.show()
	label.show()
	item_texture.texture.region.position.x = (item % 10) * 16
	item_texture.texture.region.position.y = (item / 10) * 16
	item_name = Globals.pickup_names[item]
	item_description = Globals.pickup_descriptions[item]
	
	label.text = str(amount)

func is_empty():
	return item_name == ""
	
func clear():
	item_texture.hide()
	label.hide()
	item_name = ""

func _get_drag_data(_at_position):
	if item_name == "":
		return
	
	var data  = {
		"item" : item,
		"amount" : int(label.text),
		"from" : self
	}
	
	var preview_texture = TextureRect.new()
	preview_texture.texture = item_texture.texture
	preview_texture.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	preview_texture.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	preview_texture.size = Vector2(16, 16)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	set_drag_preview(preview)
	
	drag_started.emit(data, self)
	clear()
	
	return data
	
func _can_drop_data(_at_position, _data):
	return true
	
func _drop_data(_at_position, data):
	if is_trash_bin:
		item_disposed.emit(data["item"])
		dust_emitter.emitting = true
		drop_succesful.emit()
	else:
		if item_name != "":
			data["from"].insert_item(item, int(label.text))
		insert_item(data["item"], data["amount"])
		drop_succesful.emit()
