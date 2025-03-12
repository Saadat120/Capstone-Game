extends Node2D

@onready var playerCam = $Player/Camera2D

func _ready() -> void:
	playerCam.enabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://World/Areas/WolfArena.tscn")
		
		pass # Replace with function body.
	pass # Replace with function body.

#BadgerPortal entered
func _on_badgerPortal_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Enter Badger portal")
	pass
