extends Control
class_name InventoryUI

@export var inventory : Resource

var slots : Array = []

var current_drag : Dictionary
var dragged_from : InventorySlot
var drop_succesful : bool = false

signal item_dropped(item : Globals.Pickups)

func _unhandled_key_input(event):
	if event.is_pressed() and event.keycode >= KEY_1 and event.keycode <= KEY_9:	
		if slots[event.keycode - 49].is_empty():
			return
		inventory.use_item(slots[event.keycode - 49].item)

func _input(event):
	if event is InputEventMouseButton:
		await get_tree().process_frame
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not drop_succesful and current_drag:
				if $VBoxContainer/MarginContainer/Background.get_global_rect().has_point(get_global_mouse_position()):
					dragged_from.insert_item(current_drag["item"], current_drag["amount"])
					dragged_from = null
					current_drag = {}
				else:
					item_dropped.emit(current_drag["item"])
					var initial_slot = dragged_from
					inventory.remove_item(current_drag["item"], initial_slot)
					current_drag = {}
					dragged_from = null
					#inventory.clear_slot(current_drag["item"])

func _ready():
	slots = $VBoxContainer/MarginContainer/Background/MarginContainer2/InventorySlots.get_children()
	EventBus.player_ready.connect(connect_inventory)
	
func connect_inventory(player : Forresta):
	if not inventory == player.inventory:
		inventory = player.inventory	
		inventory.inventory_changed.connect(update_inventory)
		for slot in slots:
			slot.mouse_entered.connect(slot_hovered.bind(slot))
			slot.mouse_exited.connect(slot_unhovered)
			slot.get_node("Label2").text = str(slot.get_index() + 1)
			slot.gui_input.connect(_on_gui_input.bind(slot))
			slot.drag_started.connect(_on_drag_started)
			slot.drop_succesful.connect(_on_drop_succesful)
			if slot.is_trash_bin:
				slot.item_disposed.connect(_on_item_disposed)
	reload_inventory()

func clear():
	for slot in slots:
		slot.clear()		

func get_free_slot():
	for slot in slots:
		if slot.item_name == "" and not slot.is_trash_bin:
			return slot
	return null

func find_item_slot(item : Globals.Pickups):
	for slot in slots:
		if slot.item_name == Globals.pickup_names[item]:
			return slot
	return null

func update_inventory(item : Globals.Pickups, amount : int, prefered_slot : InventorySlot = null):
	var slot : InventorySlot
	if prefered_slot:
		slot = prefered_slot
	else:
		slot = find_item_slot(item)
	if slot:
		if amount > 0:
			slot.insert_item(item, amount)
		else:
			slot.clear()
	else:
		slot = get_free_slot()
		if slot and amount > 0:
			slot.insert_item(item, amount)

func reload_inventory():
	for item in inventory.items:
		update_inventory(item, inventory.items[item])
		

func slot_hovered(slot : InventorySlot):
	if slot.item_name == "":
		return
	else:
		$VBoxContainer/VBoxContainer/ItemNameLabel.text = slot.item_name
		$VBoxContainer/VBoxContainer/DescriptionLabel.text = slot.item_description
		$VBoxContainer/VBoxContainer/ItemNameLabel.show()
		$VBoxContainer/VBoxContainer/DescriptionLabel.show()

func slot_unhovered():
	$VBoxContainer/VBoxContainer/ItemNameLabel.hide()
	$VBoxContainer/VBoxContainer/DescriptionLabel.hide()

func _on_drag_started(data : Dictionary, slot : InventorySlot):
	current_drag = data
	dragged_from = slot
	drop_succesful = false

func _on_drop_succesful():
	drop_succesful = true

func _on_item_disposed(item : Globals.Pickups):
	inventory.clear_slot(item)

func _on_gui_input(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton:
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if slot.item_name == "":
				return
			else:
				if slot.get_global_rect().has_point(get_global_mouse_position()):
					inventory.use_item(slot.item as Globals.Pickups)


func _on_tree_entered():
	pass # Replace with function body.
