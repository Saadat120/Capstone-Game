extends Node2D

@onready var camera2d: Camera2D = $Camera2D
@onready var playerCam : Camera2D= $Player/Camera2D
@onready var player: Player = $Player
@onready var player_ui: Control = $"UI/PlayerUI"
@onready var stag: CharacterBody2D = $Stag
@onready var wolf: Node2D = $wolf

var spawn: bool = false

func _ready() -> void:
	playerCam.enabled = false
	player.playerManager.canAttack = false
	player.playerManager.canMove = false
	Dialogic.start("StagArea")

func _process(_delta: float) -> void:
	player.playerManager.canAttack = Dialogic.VAR.Player.attack
	player.playerManager.canMove = Dialogic.VAR.Player.move
	if Dialogic.VAR.stagScene.pause == true:
		camera2d.enabled = false
		playerCam.enabled = true
		Dialogic.paused = true
		Dialogic.Text.hide_textbox()
		
	if stag.struck == true and spawn == false:
		Dialogic.VAR.Player.attack = false
		Dialogic.Text.show_textbox()
		Dialogic.paused = false
		Dialogic.VAR.stagScene.struck = true
		
	wolfArrival()
	wolfDefeated()
	if Dialogic.timeline_ended:
		GameState.tutorialStep = 2
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/Main.tscn")

func wolfArrival() -> void:
	if Dialogic.VAR.stagScene.wolfArrival and spawn == false:
		var wolfScene := load("res://Entities/scenes/wolfBeta.tscn")
		Dialogic.VAR.Player.attack = true
		wolfArrival()
		spawn = true
		Dialogic.paused = true
		Dialogic.Text.hide_textbox()
		if wolfScene: wolf.add_child(wolfScene.instantiate())	

func wolfDefeated() -> void:
	if wolf.get_child(0).dead == true:
		Dialogic.VAR.Player.attack = false
		Dialogic.paused = false
		Dialogic.Text.show_textbox()
