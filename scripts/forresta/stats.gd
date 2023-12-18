extends Resource
class_name StatsManager

var strength_boost_active : bool = false

@export_category("Stats")
@export var strength : int = 1 :
	set(value):
		var increase : int = value - strength
		strength = value
		base_damage += DAMAGE_INCREASE_RATE * increase
		if strength_boost_active:
			current_damage = 2 * base_damage
		stats_updated.emit()
		
@export var agility : int = 1 :
	set(value):
		var increase : int = value - agility
		agility = value
		evasion_chance += EVASION_INCREASE_RATE * increase
		stats_updated.emit()
		
@export var endurance : int = 1 :
	set(value):
		var increase : int = value - endurance
		endurance = value
		max_stamina += STAMINA_INCREASE_RATE * increase
		self.current_stamina += STAMINA_INCREASE_RATE * increase
		stats_updated.emit()
		
@export var constitution : int = 1 : 
	set(value):
		var increase : int = value - constitution
		constitution = value
		max_hp += HP_INCREASE_RATE * increase
		if increase != 0:
			self.current_hp += HP_INCREASE_RATE * increase 
		
@export var max_hp : int = 1
@export var max_stamina : int = 1
@export var max_mana : int = 99 :
	set(value):
		max_mana = value
		mana_changed.emit(float(current_mana) / max_mana * 100)

@export_category("Effect constants")
@export var dash_cooldown : float = 0.15
@export var effect_duration : float = 20.0
@export var dash_threshold : float = 5.0
@export var armour_rating : float = 1.0
#@export_category("Dependencies")
#@export var stats_holder : CharacterBody2D

const HP_INCREASE_RATE : int = 5
const STAMINA_INCREASE_RATE : int = 5
const DAMAGE_INCREASE_RATE : float = 0.5
const EVASION_INCREASE_RATE : float = 0.05

var current_hp : float :
	set(value):
		current_hp = min(value, max_hp)
		hp_changed.emit(current_hp / max_hp * 100)
		if value <= 0:
			hp_depleted.emit()

var current_stamina : float :
	set(value):
		current_stamina = min(value, max_stamina)
		stamina_changed.emit(current_stamina / max_stamina * 100)

var current_mana : float :
	set(value):
		current_mana = min(value, max_mana)
		mana_changed.emit(current_mana / max_mana * 100)

var evasion_chance : float
var base_damage : float
var current_damage : float
var affinity : Globals.Affinities

signal stats_updated
signal hp_changed(hp_percentage : float)
signal stamina_changed(stamina_percentage : float)
signal mana_changed(mana_percentage : float)
signal hp_depleted

func initialize():
#	for data in stats_data.keys():
#		self.set(data, stats_data[data])
#
	calculate_stats()
	set_initial_values()
	
func calculate_stats():
	max_hp = 20 + constitution * HP_INCREASE_RATE
	max_stamina = 15 + endurance * STAMINA_INCREASE_RATE
	evasion_chance = 0.025 * agility
	stats_updated.emit()

func set_initial_values():
	self.current_hp = max_hp
	self.current_stamina = max_stamina
	self.current_mana = 99
	self.base_damage = strength
	self.current_damage = base_damage

func change_stat_value(stat, amount):
	self.set(stat, get(stat) + amount)

func boost_damage():
	current_damage = base_damage * 2

func damage_boost_ended():
	current_damage = base_damage

func calculate_received_damage(attacker : Node2D) -> float:
	if randf() < evasion_chance and not attacker is Hazard and not attacker is Crusher:
		return -1
	return attacker.current_damage * Globals.affinity_interactions[affinity][attacker.affinity] * armour_rating

func dash() -> bool:
	if current_stamina >= dash_threshold and dash_cooldown <= 0:
		current_stamina -= dash_threshold
		return true
	return false
