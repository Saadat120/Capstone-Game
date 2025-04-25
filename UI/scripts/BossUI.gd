extends Control

@onready var bossHealthBar: ProgressBar = $VBoxContainer/Healths/Boss/HealthBar
@onready var bossHealthVal: Label = $VBoxContainer/Healths/Boss/HealthVal

@onready var MiniBossHealtBar: ProgressBar = $VBoxContainer/Healths/MiniBoss/HealthBar
@onready var MiniBossHealtVal: Label = $VBoxContainer/Healths/MiniBoss/HealthVal

func _ready() -> void:
	bossHealthVal.text = str(int(bossHealthBar.value)) + "/" + str(int(bossHealthBar.max_value))
	MiniBossHealtVal.text = str(int(MiniBossHealtBar.value)) + "/" + str(int(MiniBossHealtBar.max_value))

func _on_health_bar_value_changed(value: float) -> void:
	if bossHealthBar:
		bossHealthVal.text = str(int(bossHealthBar.value)) + "/" + str(int(bossHealthBar.max_value))


func _on_MiniBoss_health_bar_value_changed(value: float) -> void:
	if MiniBossHealtBar:
		MiniBossHealtVal.text = str(int(MiniBossHealtBar.value)) + "/" + str(int(MiniBossHealtBar.max_value))
