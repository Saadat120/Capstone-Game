extends PanelContainer

func _ready() -> void:
	hide()

func _on_yes_button_down() -> void:
	if GameState.stage == 3:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/WolfArena.tscn")
	elif GameState.stage == 5:
		GameState.challengeBoss = true
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/WolfArena.tscn")
		print("fsfs")

func _on_no_button_down() -> void:
	self.hide()
	pass # Replace with function body.
