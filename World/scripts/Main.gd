extends Node2D

@onready var playerCam := $Player/Camera2D
@onready var companion: Node2D = $Companion
@onready var player: Player = $Player

func _ready() -> void:
	if GameState.tutorialStep == 2:
		Dialogic.start("Haven")
		Dialogic.signal_event.connect(dialogic_signal)
	else:
		addPet(PlayerData.currentPet)
	playerCam.enabled = false
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/WolfArena.tscn")

#BadgerPortal entered
func _on_badgerPortal_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/badgerArena.tscn")
	pass

func dialogic_signal(signalStr: String) -> void:
	if signalStr == "Stag":
		addPet(signalStr)
	elif signalStr == "end":
		GameState.tutorialStep = 3
		PlayerData.addMarks(2)
		PlayerData.addTreats(2)
		
func addPet(pet: String) -> void:
	PlayerData.unlockPet(pet)
	PlayerData.currentPet = pet
	var companionScene := load("res://Player/scenes/" + pet + "Companion.tscn")
	if companionScene:
		companion.add_child(companionScene.instantiate())
	player.playerManager.abilitiesManager.petSpecial()
