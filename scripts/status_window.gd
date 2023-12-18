extends Control

@onready var forresta_picture : TextureRect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/MarginContainer/ForrestaPicture
@onready var strength_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Strength/StrengthLabel
@onready var agility_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Agility/AgilityLabel
@onready var endurance_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Endurance/EnduranceLabel
@onready var constitution_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Constitution/ConstitutionLabel
@onready var hp_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HP/HBoxContainer/HpLabel
@onready var max_hp_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/HP/HBoxContainer/MaxHpLabel
@onready var stamina_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Stamina/HBoxContainer/StaminaLabel
@onready var max_stamina_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Stamina/HBoxContainer/MaxStaminaLabel
@onready var mana_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Mana/HBoxContainer/ManaLabel
@onready var max_mana_label : Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Mana/HBoxContainer/MaxManaLabel

var tick : int = 0


func _process(_delta):
	tick += 1
	if tick % 10 == 0:
		forresta_picture.texture.region.position.x = wrapi(forresta_picture.texture.region.position.x + 22, 0, 132)
		tick = 0

func update_content():
	if not visible:
		return
	strength_label.text = str(Globals.player.Stats.strength)
	agility_label.text = str(Globals.player.Stats.agility)
	endurance_label.text = str(Globals.player.Stats.endurance)
	constitution_label.text = str(Globals.player.Stats.constitution)
	hp_label.text = "%d" % Globals.player.Stats.current_hp
	max_hp_label.text = str(Globals.player.Stats.max_hp)
	stamina_label.text = "%d" % Globals.player.Stats.current_stamina
	max_stamina_label.text = str(Globals.player.Stats.max_stamina)
	mana_label.text = "%d" % Globals.player.Stats.current_mana
	max_mana_label.text = str(Globals.player.Stats.max_mana)

func _on_visibility_changed():
	set_process(visible)
	if visible:
		update_content()


func _on_ok_pressed():
	hide()
