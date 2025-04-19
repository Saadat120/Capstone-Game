extends Control

@onready var healthBar: ProgressBar = $StatsContainer/Container/HealthContainer/HealthBar
@onready var healthVal: Label = $StatsContainer/Container/HealthContainer/HealthVal
@onready var treats: Label = $PanelContainer/VBoxContainer/TreatsHBox/Treats
@onready var marks: Label = $PanelContainer/VBoxContainer/MarksHBox/Marks
@onready var stagSkill: NinePatchRect = $Skills/Skill3/StagSkill
@onready var wolfSkill: NinePatchRect = $Skills/Skill3/WolfSkill
@onready var stagPassive: NinePatchRect = $StatsContainer/Passive/Stag
@onready var wolfPassive: NinePatchRect = $StatsContainer/Passive/Wolf
@onready var gauge_meter: ProgressBar = $StatsContainer/Container/GaugeContainer/GaugeMeter
@onready var gauge_value: Label = $StatsContainer/Container/GaugeContainer/GaugeValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthVal.text = str(int(healthBar.value)) + "/" + str(int(healthBar.max_value))
	gauge_value.text = str(int(gauge_meter.value)) + "/100"
	treats.text = str(PlayerData.animalTreats)
	marks.text = str(PlayerData.playerMarks)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	healthVal.text = str(int(healthBar.value)) + "/" + str(int(healthBar.max_value))
	gauge_value.text = str(int(gauge_meter.value)) + "/100"
	treats.text = str(PlayerData.animalTreats)
	marks.text = str(PlayerData.playerMarks)
	if PlayerData.currentPet == "Stag":
		stagPassive.show()
		stagSkill.show()
		wolfSkill.hide()
		wolfPassive.hide()
		gauge_meter.show()
		gauge_value.show()
	elif PlayerData.currentPet == "Wolf":
		wolfPassive.show()
		wolfSkill.show()
		stagPassive.hide()
		stagSkill.hide()
		gauge_meter.show()
		gauge_value.show()
	else:
		wolfPassive.hide()
		stagPassive.hide()
		wolfSkill.hide()
		stagSkill.hide()
		gauge_meter.hide()
		gauge_value.hide()
