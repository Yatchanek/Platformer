extends CanvasLayer

@onready var health_bar : TextureProgressBar = $Control/HBoxContainer/VBoxContainer/HealthBar
@onready var mana_bar : TextureProgressBar= $Control/HBoxContainer/VBoxContainer/ManaBar
@onready var stamina_bar : TextureProgressBar = $Control/HBoxContainer/VBoxContainer/StaminaBar
@onready var status : MarginContainer = $Control/HBoxContainer/VBoxContainer2/StatusPortrait
@onready var inventory_ui : Control = $Control/Inventory
@onready var status_window : Control = $Control/StatusWindow
@onready var speed_boost_bar = $Control/EffectBars/SpeedEffect/SpeedBoostBar
@onready var armour_boost_bar = $Control/EffectBars/ArmourEffect/ArmourBoostBar
@onready var strength_boost_bar = $Control/EffectBars/StrengthEffect/StrengthBoostBar
@onready var strength_effect = $Control/EffectBars/StrengthEffect
@onready var speed_effect = $Control/EffectBars/SpeedEffect
@onready var armour_effect = $Control/EffectBars/ArmourEffect

enum Effects {
	STR,
	SPD,
	ARM
}

var effect_bars : Dictionary = {
	
}

func _ready():
	EventBus.player_ready.connect(connect_player)

	
	effect_bars = {
	Effects.STR : [strength_effect, strength_boost_bar],
	Effects.SPD : [speed_effect,speed_boost_bar],
	Effects.ARM: [armour_effect,armour_boost_bar],
	}
	

func connect_player(player):
	player.hp_changed.connect(update_health)
	player.stamina_changed.connect(update_stamina)
	player.mana_changed.connect(update_mana)
	player.effect_started.connect(turn_on_effect)
	player.effect_duration_changed.connect(update_effect)
	player.effect_ended.connect(turn_off_efect)
	player.stats_changed.connect(update_stats)
	player.no_stamina.connect(blink_stamina_bar)
	player.no_mana.connect(blink_mana_bar)


func update_health(value : float):
	if value < health_bar.value:
		hurt()
	health_bar.update_value(value)
	status_window.update_content()
	
func update_mana(value : float):
	mana_bar.update_value(value)
	status_window.update_content()
	
func update_stamina(value : float):
	stamina_bar.update_value(value)
	status_window.update_content()

func update_stats():
	status_window.update_content()
	
func hurt():
	status.ouch()

func turn_on_effect(type : Effects):
	for child in effect_bars[type][0].get_children():
		child.show()

func update_effect(type : Effects, value : float):
	effect_bars[type][1].value = value
#	if value <= 0:
#		effect_bars[type].hide()
#		effect_bars[type].get_parent().get_child(0).hide()
	
func turn_off_efect(type : Effects):
	for child in effect_bars[type][0].get_children():
		child.hide()

func blink_stamina_bar():
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(stamina_bar, "modulate", Color.RED, 0.15)
	tw.tween_property(stamina_bar, "modulate", Color.WHITE, 0.15)

func blink_mana_bar():
	var tw = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(mana_bar, "modulate", Color.RED, 0.15)
	tw.tween_property(mana_bar, "modulate", Color.WHITE, 0.15)
