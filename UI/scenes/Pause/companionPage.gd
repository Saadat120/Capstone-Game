extends PanelContainer

@onready var treatsHeld: Label = $VBoxContainer/HBoxContainer/HBoxContainer2/PanelContainer/HBoxContainer/TreatsHeld
@onready var timer: Timer = $VBoxContainer/HBoxContainer/HBoxContainer2/Timer
@onready var insufficient: PanelContainer = $VBoxContainer/HBoxContainer/HBoxContainer2/Insufficient
@onready var companion_page: PanelContainer = $"."
@onready var stagSelect: TextureButton = $VBoxContainer/MainHBox/StagTree/PanelContainer/StagSelect
@onready var wolfSelect: TextureButton = $VBoxContainer/MainHBox/WolfTree/PanelContainer/WolfSelect


func _ready() -> void:
	treatsHeld.text = str(PlayerData.animalTreats)
	insufficient.hide()
	SignalBus.insufficientTreats.connect(showInsufficient)
	SignalBus.updateTreatsUI.connect(updateTreats)
	if PlayerData.pets.has("Stag"): stagSelect.disabled = false
	if PlayerData.pets.has("Wolf"): wolfSelect.disabled = false

func inititialize() -> void:
	if PlayerData.pets.has("Stag"): stagSelect.disabled = false
	if PlayerData.pets.has("Wolf"): wolfSelect.disabled = false
	
func showInsufficient() -> void:
	insufficient.show()
	timer.start()

func updateTreats() -> void:
	treatsHeld.text = str(PlayerData.animalTreats)

func _on_timer_timeout() -> void:
	insufficient.hide()

func _on_stag_select_button_down() -> void:
	PlayerData.currentPet = "Stag"
	var player := get_tree().get_first_node_in_group("Player")
	player.playerManager.companion = "Stag"

func _on_wolf_select_button_down() -> void:
	PlayerData.currentPet = "Wolf"
	var player := get_tree().get_first_node_in_group("Player")
	player.playerManager.companion = "Wolf"
