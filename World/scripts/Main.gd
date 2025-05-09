extends Node2D

@onready var playerCam := $Player/Camera2D
@onready var companion: Node2D = $Companion
@onready var companion2: Node2D = $Companion2

@onready var player: Player = $Player
@onready var depart: PanelContainer = $UI/Depart
@onready var wolfPortal: StaticBody2D = $WolfPortal
@onready var badgerPortal: StaticBody2D = $BadgerPortal

@onready var label: Label = $UI/Label

func _ready() -> void:
	if GameState.stage == 2:
		Dialogic.start("Haven")
		Dialogic.signal_event.connect(dialogic_signal)
	elif GameState.stage == 4:
		Dialogic.start("WolfCompanion")
		Dialogic.signal_event.connect(dialogic_signal)
	elif GameState.stage == 6:
		Dialogic.start("AlphaDefeated")
		Dialogic.signal_event.connect(dialogic_signal)
	if GameState.stage > 3:
		wolfPortal.show()
	loadPets()
	playerCam.enabled = false
	if GameState.stage == 7:
		label.show()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameState.stage > 4:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/WolfArena.tscn")
		label.hide()

#BadgerPortal entered
func _on_badgerPortal_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameState.stage > 5:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/badgerArena.tscn")
	pass

func dialogic_signal(signalStr: String) -> void:
	if signalStr == "Stag":
		addPet(signalStr)
	elif signalStr == "end":
		GameState.stage = 3
		PlayerData.addMarks(3)
		PlayerData.addTreats(2)
	elif signalStr == "Wolf":
		addPet(signalStr)
		GameState.stage = 5
		player.playerManager.canMove = true
		player.playerManager.canAttack = true
	elif signalStr == "endGame":
		GameState.stage = 7
		label.show()
		
func addPet(pet: String) -> void:
	PlayerData.unlockPet(pet)
	PlayerData.currentPet = pet
	if pet == "Stag":
		$UI/PauseArea/CompanionPage/VBoxContainer/MainHBox/StagTree/StagSkillTree/Panel/BaseSkill.unlockRoot(pet)
	elif pet == "Wolf":
		$UI/PauseArea/CompanionPage/VBoxContainer/MainHBox/WolfTree/WolfSkillTree/Panel/BaseSkill.unlockRoot(pet)
	player.playerManager.companion = pet
	var companionScene := load("res://Player/scenes/" + pet + "Companion.tscn")
	if companionScene:
		companion.add_child(companionScene.instantiate())

func loadPets() -> void:
	for pet:String in PlayerData.pets:
		var companionScene := load("res://Player/scenes/" + pet + "Companion.tscn")
		if companionScene:
			companion.add_child(companionScene.instantiate())

func _on_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and GameState.stage > 2:
		depart.show()
		depart.enemyDisplay()

func _on_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and GameState.stage > 2:
		depart.hide()
