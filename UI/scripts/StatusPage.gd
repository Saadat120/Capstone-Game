extends PanelContainer

@onready var healthLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Vitality/HBoxContainer/HBoxContainer2/HealthLvl
@onready var healthValue: Label = $HBoxContainer/StatDetails/StatsContent/HealthDetails/MaxHealth/HealthVal

@onready var damageLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Damage/HBoxContainer/HBoxContainer2/DamageLvl
@onready var damageValue: Label = $HBoxContainer/StatDetails/StatsContent/DamageDetails/Damage/DamageVal

@onready var agilityLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Agility/HBoxContainer/HBoxContainer2/AgilityLvl
@onready var agilityValue: Label = $HBoxContainer/StatDetails/StatsContent/AgilityDetails/Agility/AgilityVal

@onready var armorLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Armor/HBoxContainer/HBoxContainer2/ArmorLvl
@onready var armorValue: Label = $HBoxContainer/StatDetails/StatsContent/ArmorDetails/Armor/ArmorVal

@onready var healthInc: Label = $HBoxContainer/StatDetails/StatsContent/HealthDetails/HealthIncrease
@onready var damageInc: Label = $HBoxContainer/StatDetails/StatsContent/DamageDetails/DamageIncrease
@onready var agilityInc: Label = $HBoxContainer/StatDetails/StatsContent/AgilityDetails/AgilityIncrease
@onready var armorInc: Label = $HBoxContainer/StatDetails/StatsContent/ArmorDetails/ArmorIncrease


func _ready() -> void:
	healthInc.hide()
	damageInc.hide()
	agilityInc.hide()
	armorInc.hide()


func update() -> void:
	healthLevel.text = str(GlobalPlayer.healthStats["level"])
	healthValue.text = str(GlobalPlayer.healthStats["value"])
	
	damageLevel.text = str(GlobalPlayer.damageStats["level"])
	damageValue.text = str(GlobalPlayer.damageStats["value"])
	
	agilityLevel.text = str(GlobalPlayer.agilityStats["level"])
	agilityValue.text = str(GlobalPlayer.agilityStats["value"])
	
	armorLevel.text = str(GlobalPlayer.armorStats["level"])
	armorValue.text = str(GlobalPlayer.armorStats["value"])

func _on_hlth_button_mouse_entered() -> void:
	if GlobalPlayer.healthStats["level"] < 5:
		var healthIncVal: int = (10 * GlobalPlayer.healthStats["level"])
		healthInc.text = "+" + str(healthIncVal)
		healthInc.show()

func _on_hlth_button_mouse_exited() -> void:
	healthInc.hide()

func _on_dmg_button_mouse_entered() -> void:
	if GlobalPlayer.damageStats["level"] < 5:
		var dmgIncVal: int = (30 * GlobalPlayer.damageStats["level"])/5
		damageInc.text = "+" + str(dmgIncVal)
		damageInc.show()

func _on_dmg_button_mouse_exited() -> void:
	damageInc.hide()

func _on_agility_button_mouse_entered() -> void:
	if GlobalPlayer.agilityStats["level"] < 5:
		agilityInc.text = "+8"
		agilityInc.show()

func _on_agility_button_mouse_exited() -> void:
	agilityInc.hide()

func _on_armor_button_mouse_entered() -> void:
	if GlobalPlayer.armorStats["level"] < 5:
		armorInc.text = "+10"
		armorInc.show()

func _on_armor_button_mouse_exited() -> void:
	armorInc.hide()
