extends PanelContainer

@onready var mainMenu: HBoxContainer = $MainMenu
@onready var statusPage: PanelContainer = $StatusPage
@onready var companionPage: PanelContainer = $CompanionPage
var player : CharacterBody2D
var paused := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	statusPage.hide()
	companionPage.hide()
	player = get_tree().get_first_node_in_group("Player")
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if paused == false:
			pause()
		elif paused == true:
			if !statusPage.is_visible_in_tree() and !companionPage.is_visible_in_tree() :
				resume()
			elif statusPage.is_visible_in_tree():
				mainMenu.show()
				statusPage.hide()
			elif companionPage.is_visible_in_tree():
				mainMenu.show()
				companionPage.hide()

func resume() -> void:
	#get_tree().paused = false
	player.playerManager.canMove = true
	player.playerManager.canAttack = true
	paused = false
	hide()	

func pause() -> void:
	show()
	paused = true
	player.playerManager.canMove = false
	player.playerManager.canAttack = false
	#get_tree().paused = true

func _on_status_button_down() -> void:
	mainMenu.hide()
	companionPage.hide()
	statusPage.show()
	statusPage.update()
	
func _on_companion_button_down() -> void:
	mainMenu.hide()
	statusPage.hide()
	companionPage.show()
	companionPage.updateTreats()
	
func _on_exit_button_down() -> void:
	GameState.saveProgress()
	get_tree().quit()
	#if Dialogic.timeline_started:
		#Dialogic.end_timeline()
	#get_tree().change_scene_to_file("res://World/scenes/startMenu.tscn")
