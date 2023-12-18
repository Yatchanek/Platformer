extends Node

var player : Forresta

enum Affinities {
	FIRE,
	WATER,
	ICE,
	#AIR,
	ACID,
	ELECTRICITY,
	POISON,
	NONE,
}

enum Pickups {
	POTION_HEALTH,
	POTION_STAMINA,
	POTION_SPEED,
	POTION_MANA,
	POTION_STRENGTH,
	TOME_CONSTITUTION,
	TOME_ENDURANCE,
	TOME_AGILITY,
	TOME_MANA,
	TOME_STRENGTH,
	KEY_GOLD,
	KEY_SILVER,
	KEY_RED,
	KEY_BLUE
}

var pickup_names : Dictionary = {
	Pickups.POTION_HEALTH : "Potion of Health",
	Pickups.POTION_STAMINA : "Potion of Stamina",
	Pickups.POTION_SPEED : "Potion of Speed",
	Pickups.POTION_MANA : "Potion of Mana",
	Pickups.POTION_STRENGTH : "Potion of Strength",
	Pickups.KEY_GOLD : "Gold Key",
	Pickups.KEY_SILVER : "Silver Key",
	Pickups.KEY_RED : "Red Key",
	Pickups.KEY_BLUE : "Blue Key",
	Pickups.TOME_CONSTITUTION : "Tome of Constitution",
	Pickups.TOME_AGILITY : "Tome of Agility",
	Pickups.TOME_ENDURANCE : "Tome of Endurance",
	Pickups.TOME_MANA : "Tome of Mana",
	Pickups.TOME_STRENGTH : "Tome of Strength"
}

var pickup_descriptions : Dictionary = {
	Pickups.POTION_HEALTH : "Restores your health",
	Pickups.POTION_STAMINA : "Restores your stamina",
	Pickups.POTION_SPEED : "Temporary speed boost",
	Pickups.POTION_MANA : "Restores your mana",
	Pickups.POTION_STRENGTH : "Temporary damage boost",
	Pickups.KEY_GOLD : "",
	Pickups.KEY_SILVER : "",
	Pickups.KEY_RED : "",
	Pickups.KEY_BLUE : "",
	Pickups.TOME_CONSTITUTION : "Increases constitution",
	Pickups.TOME_AGILITY : "Increases agility",
	Pickups.TOME_ENDURANCE : "Increases Endurance",
	Pickups.TOME_MANA : "Icreases max mana",
	Pickups.TOME_STRENGTH : "Increases strength"
} 

var affinity_interactions : Dictionary = {
	Affinities.FIRE : {
		Affinities.FIRE : 1.0,
		Affinities.WATER : 2.0,
		Affinities.ICE : 0.5,
		#Affinities.AIR : 1.0,
		Affinities.ACID : 1.0,
		Affinities.ELECTRICITY : 1.0,
		Affinities.POISON: 1.0,
		Affinities.NONE : 0.5
	},
	
	Affinities.WATER : {
		Affinities.FIRE : 0.5,
		Affinities.WATER : 1.0,
		Affinities.ICE : 1.5,
		#Affinities.AIR : 1.0,
		Affinities.ACID : 1.0,
		Affinities.ELECTRICITY : 1.5,
		Affinities.POISON: 1.0,
		Affinities.NONE : 0.5
	},
	
	Affinities.ICE : {
		Affinities.FIRE : 2.0,
		Affinities.WATER : 1.5,
		Affinities.ICE : 1.0,
		#Affinities.AIR : 0.5,
		Affinities.ACID : 0.5,
		Affinities.ELECTRICITY : 1.0,
		Affinities.POISON: 1.0,
		Affinities.NONE : 0.5
	},
	
#	Affinities.AIR : {
#		Affinities.FIRE : 1.5,
#		Affinities.WATER : 0.5,
#		Affinities.ICE : 1.0,
#		#Affinities.AIR : 1.0,
#		Affinities.ACID : 1.0,
#		Affinities.ELECTRICITY : 1.0,
#		Affinities.POISON: 1.5,
#		Affinities.NONE : 0.5
#	},
	Affinities.ACID : {
		Affinities.FIRE : 1.0,
		Affinities.WATER : 1.5,
		Affinities.ICE : 1.25,
		#Affinities.AIR : 1.0,
		Affinities.ACID : 1.0,
		Affinities.ELECTRICITY : 0.5,
		Affinities.POISON: 0.5,
		Affinities.NONE : 0.5
	},
		
	Affinities.ELECTRICITY : {
		Affinities.FIRE : 1.0,
		Affinities.WATER : 0.5,
		Affinities.ICE : 1.0,
		#Affinities.AIR : 1.0,
		Affinities.ACID : 1.0,
		Affinities.ELECTRICITY : 1.0,
		Affinities.POISON: 1.0,
		Affinities.NONE : 0.5
	},
	
	Affinities.POISON : {
		Affinities.FIRE : 1.0,
		Affinities.WATER : 2.0,
		Affinities.ICE : 1.0,
		#Affinities.AIR : 1.0,
		Affinities.ACID : 1.0,
		Affinities.ELECTRICITY : 1.0,
		Affinities.POISON: 1.0,
		Affinities.NONE : 0.5
	},
	
	Affinities.NONE : {
	Affinities.FIRE : 1.5,
	Affinities.WATER : 1.5,
	Affinities.ICE : 1.5,
	#Affinities.AIR : 1.5,
	Affinities.ACID : 1.5,
	Affinities.ELECTRICITY : 1.5,
	Affinities.POISON: 1.5,
	Affinities.NONE : 1.0
}
}

var affinity_colors : Dictionary = {
	Affinities.FIRE : Color(1.0, 0.2, 0.2),
	Affinities.WATER : Color(0.3, 0.5, 0.9),
	Affinities.ICE : Color(0.7, 0.9, 0.9),
	#Affinities.AIR : Color.SKY_BLUE,
	Affinities.ACID : Color(0.15, 0.8, 0.2),
	Affinities.ELECTRICITY : Color(0.95, 0.9, 0.05),
	Affinities.POISON : Color(0.8, 0.25, 0.9),
	Affinities.NONE : Color.DARK_GRAY
}



var affinity_gradients : Dictionary = {
	Globals.Affinities.FIRE : "res://resources/fire_gradient_texture_1d.tres",
	Globals.Affinities.ICE : "res://resources/ice_gradient_texture_1d.tres",
	Globals.Affinities.ACID : "res://resources/acid_gradient_texture_1d.tres",
	Globals.Affinities.POISON : "res://resources/poison_gradient_texture_1d.tres"
}

const TILE_SIZE : int = 16

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var tombstone_locations : Array[Vector2] = []



func cantor(a : int, b : int) -> int:
	return int(0.5 * (a + b) * (a + b + 1) + b)

var player_data : StatsManager
var player_inventory : Inventory

func add_tombstone(tombstone : Vector2):
	tombstone_locations.append(tombstone)
	if tombstone_locations.size() > 10:
		tombstone_locations.pop_front()

signal player_ready(_player : Forresta)
