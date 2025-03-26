extends Node2D

@onready var playerCam : Camera2D= $Player/Camera2D
@onready var camera_2d: Camera2D = $Camera2D
@onready var enterTimer: Timer = $EnterTimer
@onready var returnTimer: Timer = $ReturnTimer
@onready var returnLabel: Label = $CanvasLayer/ReturnLabel
@onready var companion: Node2D = $Companion

var isBossDefeated := false

func _ready() -> void:
	SignalBus.bossDefeated.connect(onBossDefeated)
	returnLabel.visible = false
	addPet()

func _process(_delta: float) -> void:
	if isBossDefeated:
		returnLabel.visible = true
		returnLabel.text = "Return to Base: " + str(int(returnTimer.time_left))

func _on_timer_timeout() -> void:
	camera_2d.enabled = false
	playerCam.enabled = true
	pass # Replace with function body.

func onBossDefeated() -> void:
	returnTimer.start()
	isBossDefeated = true

func _on_return_timer_timeout() -> void:
	get_parent().get_tree().change_scene_to_file("res://World/Areas/Main.tscn")
	pass # Replace with function body.

func addPet() -> void:
	var companionScene := load("res://Player/scenes/stagCompanion.tscn")
	if companionScene:
		companion.add_child(companionScene.instantiate())
