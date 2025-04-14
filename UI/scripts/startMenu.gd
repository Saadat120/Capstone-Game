extends Control

func _on_play_button_down() -> void:
	if GameState.tutorialStep == 0:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/Tutorial.tscn")
	elif GameState.tutorialStep == 1:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/stagArea.tscn")
	else:
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file("res://World/scenes/Main.tscn")

func _on_quit_button_down() -> void:
	get_tree().quit()
