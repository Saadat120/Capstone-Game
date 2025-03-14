extends Node2D

@onready var playerCam = $Player/Camera2D

func _ready() -> void:
	playerCam.enabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file.call_deferred("res://World/Areas/WolfArena.tscn")

#BadgerPortal entered
func _on_badgerPortal_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file.call_deferred("res://World/Areas/badgerArena.tscn")
	pass
