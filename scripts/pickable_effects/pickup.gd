extends Resource
class_name Pickup

var description : String
var type : Globals.Pickups
var amount : int

var effects : Dictionary = {
	Globals.Pickups.POTION_HEALTH : "heal",
	Globals.Pickups.POTION_MANA : "restore_mana",
	Globals.Pickups.POTION_SPEED : "speed_boost",
	Globals.Pickups.POTION_STAMINA : "restore_stamina",
	Globals.Pickups.POTION_STRENGTH : "strength_boost",
	Globals.Pickups.TOME_CONSTITUTION : "constitution",
	Globals.Pickups.TOME_AGILITY : "agility",
	Globals.Pickups.TOME_ENDURANCE : "endurance",
	Globals.Pickups.TOME_MANA : "max_mana",
	Globals.Pickups.TOME_STRENGTH : "strength"
}



func initialize(_type : Globals.Pickups):
	type = _type
	description = Globals.pickup_names[type]
	amount = 1

func apply():
	if type >= Globals.Pickups.TOME_CONSTITUTION:
		Globals.player.call("upgrade_stat", effects[type], amount)
	else:
		Globals.player.call(effects[type])
