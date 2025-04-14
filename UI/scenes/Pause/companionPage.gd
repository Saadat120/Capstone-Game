extends PanelContainer

@onready var treatsHeld: Label = $VBoxContainer/HBoxContainer/HBoxContainer2/PanelContainer/HBoxContainer/TreatsHeld
@onready var timer: Timer = $VBoxContainer/HBoxContainer/HBoxContainer2/Timer
@onready var insufficient: PanelContainer = $VBoxContainer/HBoxContainer/HBoxContainer2/Insufficient
@onready var companion_page: PanelContainer = $"."


func _ready() -> void:
	treatsHeld.text = str(PlayerData.animalTreats)
	insufficient.hide()
	SignalBus.insufficientTreats.connect(showInsufficient)
	SignalBus.updateTreatsUI.connect(updateTreats)

func showInsufficient() -> void:
	insufficient.show()
	timer.start()

func updateTreats() -> void:
	treatsHeld.text = str(PlayerData.animalTreats)

func _on_timer_timeout() -> void:
	insufficient.hide()
