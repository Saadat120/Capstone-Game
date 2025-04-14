class_name SkillNode extends TextureButton

@onready var panel: Panel = $Panel
@onready var lock: TextureRect = $MarginContainer/Lock
@onready var line_2d: Line2D = $Line2D

@export var companionName: String
@export var branchName: String # "branch1" or "branch2"
@export var branchIndex: int # 0 or 1 (for each leaf in the branch)

@export var skillCost: int

func _ready() -> void:
	if get_parent() is SkillNode:
		line_2d.add_point(global_position + size/2)
		line_2d.add_point(get_parent().global_position + size/2)
	
	 #Lock or unlock based on save data
	if PlayerData.companionAbilities[companionName][branchName][branchIndex]:
		panel.show_behind_parent = true
		lock.hide()
		disabled = true
		var skills := get_children()
		for skill in skills:
			if skill is SkillNode: skill.disabled = false
	
func unlockRoot(petName: String) -> void:
	if petName != companionName: return
	# Lock or unlock based on save data
	if PlayerData.companionAbilities[petName]["root"][0]:
		panel.show_behind_parent = true
		lock.hide()
		disabled = true
		var skills := get_children()
		for skill in skills:
			if skill is SkillNode: skill.disabled = false

func _on_button_down() -> void:
	#if PlayerData.currentPet != companionName and companionName in PlayerData.pets:
		#PlayerData.currentPet = companionName
	if companionName not in PlayerData.pets: return
		
	if PlayerData.animalTreats >= skillCost:
		var skills := get_children()
		panel.show_behind_parent = true
		lock.hide()
		disabled = true
		PlayerData.animalTreats -= skillCost
		SignalBus.updateTreatsUI.emit()
		
		if PlayerData.companionAbilities.has(companionName):
			if PlayerData.companionAbilities[companionName].has(branchName):
				PlayerData.companionAbilities[companionName][branchName][branchIndex] = true
		for skill in skills:
			if skill is SkillNode:
				skill.disabled = false
	else:
		SignalBus.insufficientTreats.emit()
		
