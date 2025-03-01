extends Control

@onready var healthBar: ProgressBar = $HealthBar
@onready var abilityMeter: ProgressBar = $AbilityMeter
@onready var healthVal: Label = $HealthVal
@onready var skillVal: Label = $SkillVal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthVal.text = str(healthBar.value)
	skillVal.text = str(abilityMeter.value)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	healthVal.text = str(healthBar.value)
	skillVal.text = str(abilityMeter.value)
	pass
