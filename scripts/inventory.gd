extends Resource
class_name Inventory

@export var max_size : int = 11

var items : Dictionary = {}

signal inventory_changed(item_name, amount)

func insert_item(item : Globals.Pickups) -> bool:
	if items.has(item):
		items[item] += 1
		inventory_changed.emit(item, items[item])
		return true
	elif items.size() < max_size:
		items[item] = 1
		inventory_changed.emit(item, items[item])
		return true
	return false

func use_item(item : Globals.Pickups) -> bool:
	if not items.has(item):
		return false
	if item < Globals.Pickups.KEY_GOLD:
		var resource = Pickup.new()
		resource.initialize(item)
		resource.apply()
		items[item] -= 1
		inventory_changed.emit(item, items[item])
		if items[item] == 0:
			items.erase(item)
		return true
	return false

func clear_slot(item : Globals.Pickups):
	if items.has(item):
		items.erase(item)

func remove_item(item : Globals.Pickups, slot : InventorySlot = null):
	if not items.has(item):
		return
	items[item] -= 1
	inventory_changed.emit(item, items[item], slot)
	if items[item] == 0:
		items.erase(item)	
