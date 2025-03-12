extends Control

func _ready() -> void:
	hide()
	set_process_unhandled_input(true)
	
func resume():
	print("Resuming")
	get_tree().paused = false
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if get_tree().paused == false:
			pause()
		elif get_tree().paused == true:
			resume()

func pause():
	show()
	get_tree().paused = true

func _on_resume_pressed() -> void:
	resume()
	pass

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
