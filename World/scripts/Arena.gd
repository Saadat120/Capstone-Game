extends Node2D

@onready var playerCam : Camera2D= $Player/Camera2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var returnTimer: Timer = $ReturnTimer
@onready var returnLabel: Label = $CanvasLayer/ReturnLabel
@onready var companion: Node2D = $Companion
@onready var player: Player = $Player
@onready var enemy: Node2D = $Enemy

var isBossDefeated := false

func _ready() -> void:
	if GameState.challengeBoss:
		loadBoss("WolfAlpha")
	else:
		loadBoss("WolfBoss")
	SignalBus.bossDefeated.connect(onBossDefeated)
	returnLabel.visible = false
	addPet()
	set_process(false)

func _process(_delta: float) -> void:
	if isBossDefeated:
		returnLabel.visible = true
		returnLabel.text = "Return to Base: " + str(int(returnTimer.time_left))

func _on_timer_timeout() -> void:
	camera_2d.enabled = false
	playerCam.enabled = true

func onBossDefeated() -> void:
	if GameState.stage == 3:
		Dialogic.start("WolfArena")
		await Dialogic.timeline_ended
		GameState.stage = 4
	set_process(true)
	returnTimer.start()
	isBossDefeated = true

func _on_return_timer_timeout() -> void:
	set_process(false)
	TransitionScreen.transition()
	await TransitionScreen.transitionFinished
	get_parent().get_tree().change_scene_to_file("res://World/scenes/Main.tscn")

func loadBoss(wolfEnemy: String) -> void:
	var enemyScene := load("res://Entities/scenes/%s.tscn" %wolfEnemy)
	if enemyScene:
		enemy.add_child(enemyScene.instantiate())
		
func addPet() -> void:
	var companionScene := load("res://Player/scenes/%sCompanion.tscn" %player.playerManager.companion)
	if companionScene:
		companion.add_child(companionScene.instantiate())
