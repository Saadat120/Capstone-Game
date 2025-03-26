extends PanelContainer

@onready var mainMenu: HBoxContainer = $MainMenu
@onready var statusPage: PanelContainer = $StatusPage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(self)
	hide()
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if get_tree().paused == false:
			pause()
		elif get_tree().paused == true:
			if !statusPage.is_visible_in_tree():
				resume()
			elif statusPage.is_visible_in_tree():
				mainMenu.show()
				statusPage.hide()

func resume() -> void:
	get_tree().paused = false
	hide()	

func pause() -> void:
	show()
	get_tree().paused = true

func _on_status_button_down() -> void:
	mainMenu.hide()
	statusPage.show()
	#hide()  # Hide pause menu instead of changing scene

func _on_exit_button_down() -> void:
	get_tree().quit()
