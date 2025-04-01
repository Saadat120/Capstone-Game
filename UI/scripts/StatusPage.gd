extends PanelContainer

@onready var healthLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Vitality/VitalityBox/UpgradeReq/LevelBox/HealthLvl
@onready var healthValue: Label = $HBoxContainer/StatDetails/StatsContent/HealthDetails/MaxHealth/HealthVal
@onready var healthMarkCost: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Vitality/VitalityBox/UpgradeReq/MarkBox/MarkCost

@onready var damageLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Damage/DamageBox/UpgradeReq/LevelBox/DamageLvl
@onready var damageValue: Label = $HBoxContainer/StatDetails/StatsContent/DamageDetails/Damage/DamageVal
@onready var damageMarkCost: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Damage/DamageBox/UpgradeReq/MarkBox/MarkCost

@onready var agilityLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Agility/AgilityBox/UpgradeReq/LevelBox/AgilityLvl
@onready var agilityValue: Label = $HBoxContainer/StatDetails/StatsContent/AgilityDetails/Agility/AgilityVal
@onready var agilityMarkCost: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Agility/AgilityBox/UpgradeReq/MarkBox/MarkCost

@onready var armorLevel: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Armor/ArmorBox/HBoxContainer/LevelBox/ArmorLvl
@onready var armorValue: Label = $HBoxContainer/StatDetails/StatsContent/ArmorDetails/Armor/ArmorVal
@onready var armorMarkCost: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Armor/ArmorBox/HBoxContainer/MarkBox/MarkCost

@onready var marksHeld: Label = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/MarksHeld/HBoxContainer/MarksCount

@onready var healthInc: Label = $HBoxContainer/StatDetails/StatsContent/HealthDetails/HealthIncrease
@onready var damageInc: Label = $HBoxContainer/StatDetails/StatsContent/DamageDetails/DamageIncrease
@onready var agilityInc: Label = $HBoxContainer/StatDetails/StatsContent/AgilityDetails/AgilityIncrease
@onready var armorInc: Label = $HBoxContainer/StatDetails/StatsContent/ArmorDetails/ArmorIncrease

@onready var statTitle: Label = $HBoxContainer/StatDetails/UpgradeDetails/PanelContainer/VBoxContainer/StatTitle
@onready var insufficient: PanelContainer = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Insufficient
@onready var timer: Timer = $HBoxContainer/StatsUpgradeVBox/StatsUpgrade/Timer

@onready var vitalityDetails: Label = $HBoxContainer/StatDetails/UpgradeDetails/PanelContainer/VBoxContainer/VitalityDetails
@onready var damageDetails: Label = $HBoxContainer/StatDetails/UpgradeDetails/PanelContainer/VBoxContainer/DamageDetails
@onready var agilityDetails: Label = $HBoxContainer/StatDetails/UpgradeDetails/PanelContainer/VBoxContainer/AgilityDetails
@onready var armorDetails: Label = $HBoxContainer/StatDetails/UpgradeDetails/PanelContainer/VBoxContainer/ArmorDetails

func _ready() -> void:
	healthInc.hide()
	damageInc.hide()
	agilityInc.hide()
	armorInc.hide()
	insufficient.hide()


func update() -> void:
	healthLevel.text = str(int(GlobalPlayer.healthStats["level"]))
	healthValue.text = str(int(GlobalPlayer.healthStats["value"]))
	if GlobalPlayer.healthStats["level"] < 5: 
		healthInc.text = "+" + str((10 * GlobalPlayer.healthStats["level"]))
		healthMarkCost.text = str(GlobalPlayer.healthStats["level"])
	else:
		healthInc.hide()
	
	damageLevel.text = str(int(GlobalPlayer.damageStats["level"]))
	damageValue.text = str(int(GlobalPlayer.damageStats["value"]))
	if GlobalPlayer.damageStats["level"] < 5: 
		damageInc.text = "+" + str((30 * GlobalPlayer.damageStats["level"])/5)
		damageMarkCost.text = str(GlobalPlayer.damageStats["level"])
	else: damageInc.hide()
	
	agilityLevel.text = str(int(GlobalPlayer.agilityStats["level"]))
	agilityValue.text = str(int(GlobalPlayer.agilityStats["value"]))
	if GlobalPlayer.agilityStats["level"] < 5: 
		agilityInc.text = "+8"
		agilityMarkCost.text = str(GlobalPlayer.agilityStats["level"])
	else: agilityInc.hide()
	
	armorLevel.text = str(int(GlobalPlayer.armorStats["level"]))
	armorValue.text = str(int(GlobalPlayer.armorStats["value"]))
	if GlobalPlayer.armorStats["level"] < 5: 
		armorInc.text = "+10"
		armorMarkCost.text = str(GlobalPlayer.armorStats["level"])
	else: armorInc.hide()
	
	marksHeld.text = str(GlobalPlayer.playerMarks)
		
func _on_hlth_button_mouse_entered() -> void:
	showDetails("vitality")
	if GlobalPlayer.healthStats["level"] < 5:
		var healthIncVal: int = (10 * GlobalPlayer.healthStats["level"])
		healthInc.text = "+" + str(healthIncVal)
		healthInc.show()

func _on_hlth_button_mouse_exited() -> void:
	healthInc.hide()

func _on_dmg_button_mouse_entered() -> void:
	showDetails("damage")
	if GlobalPlayer.damageStats["level"] < 5:
		var dmgIncVal: int = (30 * GlobalPlayer.damageStats["level"])/5
		damageInc.text = "+" + str(dmgIncVal)
		damageInc.show()

func _on_dmg_button_mouse_exited() -> void:
	damageInc.hide()

func _on_agility_button_mouse_entered() -> void:
	showDetails("agility")
	if GlobalPlayer.agilityStats["level"] < 5:
		agilityInc.text = "+8"
		agilityInc.show()
		
func _on_agility_button_mouse_exited() -> void:
	agilityInc.hide()

func _on_armor_button_mouse_entered() -> void:
	showDetails("armor")
	if GlobalPlayer.armorStats["level"] < 5:
		armorInc.text = "+10"
		armorInc.show()

func _on_armor_button_mouse_exited() -> void:
	armorInc.hide()

func _on_hlth_button_button_down() -> void:
	if GlobalPlayer.healthStats["level"] < 5:
		if GlobalPlayer.playerMarks > 0 and int(healthMarkCost.text) <= GlobalPlayer.playerMarks:
			GlobalPlayer.upgradeStat("vitality", int(healthMarkCost.text))
			update()
		else:
			timer.start()
			insufficient.show()

func _on_dmg_button_button_down() -> void:
	if GlobalPlayer.damageStats["level"] < 5:
		if GlobalPlayer.playerMarks > 0 and int(damageMarkCost.text) <= GlobalPlayer.playerMarks:
			GlobalPlayer.upgradeStat("damage", int(damageMarkCost.text))
			update()
		else:
			timer.start()
			insufficient.show()

func _on_agility_button_button_down() -> void:
	if GlobalPlayer.agilityStats["level"] < 5:
		if GlobalPlayer.playerMarks > 0 and int(agilityMarkCost.text) <= GlobalPlayer.playerMarks:
			GlobalPlayer.upgradeStat("agility", int(agilityMarkCost.text))
			update()
		else:
			timer.start()
			insufficient.show()

func _on_armor_button_button_down() -> void:
	if GlobalPlayer.armorStats["level"] < 5:
		if GlobalPlayer.playerMarks > 0 and int(armorMarkCost.text) <= GlobalPlayer.playerMarks:
				GlobalPlayer.upgradeStat("armor", int(armorMarkCost.text))
				update()
		else:
			timer.start()
			insufficient.show()

func _on_timer_timeout() -> void:
	insufficient.hide()

func showDetails(stat: String) -> void:
	if stat == "vitality":
		statTitle.text = "Vitality"
		vitalityDetails.show()
		damageDetails.hide()
		agilityDetails.hide()
		armorDetails.hide()
	elif stat == "damage":
		statTitle.text = "Damage"
		damageDetails.show()
		vitalityDetails.hide()
		agilityDetails.hide()
		armorDetails.hide()
	elif stat == "agility":
		statTitle.text = "Agility"
		agilityDetails.show()
		vitalityDetails.hide()
		damageDetails.hide()
		armorDetails.hide()
	elif stat == "armor":
		statTitle.text = "Armor"
		armorDetails.show()
		vitalityDetails.hide()
		damageDetails.hide()
		agilityDetails.hide()
