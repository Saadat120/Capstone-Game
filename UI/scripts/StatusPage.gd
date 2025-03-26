extends PanelContainer

func _ready() -> void:
	show()
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		close_status_page()

func close_status_page() -> void:
	queue_free()  # Closes the status page
	var pause_menu = get_parent().find_child("PauseMenu", true, false)
	if pause_menu:
		pause_menu.show()  # Reopen the pause menu
