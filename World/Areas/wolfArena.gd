extends Node2D

@onready var playerCam = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerCam.enabled = true
	pass # Replace with function body.
