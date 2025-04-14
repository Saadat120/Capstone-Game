extends Node2D

@onready var player_ui: Control = $"UI/PlayerUI"
@onready var upgradeMaterials: PanelContainer = $"UI/PlayerUI/PanelContainer"
@onready var player: Player = $Player

var showUI := false

func _ready() -> void:
	player_ui.hide()
	Dialogic.start("tutorial")
	Dialogic.VAR.introVar.opening = GameState.intro

func _process(_delta: float) -> void:
	if Dialogic.VAR.introVar.showUI:
		player_ui.show()
	
	player.playerManager.canMove = Dialogic.VAR.Player.move
	player.playerManager.canAttack = Dialogic.VAR.Player.attack 

	if Dialogic.VAR.introVar.basicsDone:
		GameState.intro = true
		GameState.tutorialStep = 1
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/stagArea.tscn")
		set_process(false)
