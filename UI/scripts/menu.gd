extends NinePatchRect

func _ready() -> void:
	hide()
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if get_tree().paused == false:
			pause()
		elif get_tree().paused == true:
			_on_resume_button_down()

func _on_resume_button_down() -> void:
	resume()
	
func _on_restart_button_down() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_quit_button_down() -> void:
	get_tree().quit()
	pass # Replace with function body.

func resume() -> void:
	get_tree().paused = false
	hide()	

func pause():
	show()
	get_tree().paused = true
