extends PanelContainer

@onready var health: Label = $VBoxContainer/VBoxContainer2/PanelContainer/Stats/Health
@onready var damage: Label = $VBoxContainer/VBoxContainer2/PanelContainer/Stats/Damage
@onready var agility: Label = $VBoxContainer/VBoxContainer2/PanelContainer/Stats/Agility
@onready var armor: Label = $VBoxContainer/VBoxContainer2/PanelContainer/Stats/Armor

func _ready() -> void:
	enemyDisplay()
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
	elif GameState.stage == 7:
		GameState.challengeBoss = true
		TransitionScreen.transition()
		await TransitionScreen.transitionFinished
		get_tree().change_scene_to_file.call_deferred("res://World/scenes/WolfArena.tscn")
	#elif GameState.stage == 7:
		#TransitionScreen.transition()
		#await TransitionScreen.transitionFinished
		#get_tree().change_scene_to_file.call_deferred("res://World/scenes/badgerArena.tscn")

func _on_no_button_down() -> void:
	self.hide()
	pass # Replace with function body.

func enemyDisplay() -> void:
	if GameState.stage == 3:
		health.text = "Health: 700"
		damage.text = "Damage: 15"
		agility.text = "Agility: 70"
		armor.text = "Armor: 0"
	elif GameState.stage == 5:
		health.text = "Health: 1500"
		damage.text = "Damage: 50"
		agility.text = "Agility: 90"
		armor.text = "Armor: 0"
	elif GameState.stage > 5:
		health.text = "Health: 1500"
		damage.text = "Damage: 50"
		agility.text = "Agility: 90"
		armor.text = "Armor: 0"
