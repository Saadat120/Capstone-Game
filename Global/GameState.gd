extends Node

var intro:bool = true
var stage := 0
var challengeBoss: bool = false

var healthBarLength : int = 400
var defaultLength : int = 400

#func _ready() -> void:
	#loadProgress()

func saveProgress() -> void:
	var saveData := {
		"stage": stage,
		"healthBarLength": healthBarLength,
		"Treats": PlayerData.animalTreats,
		"Marks": PlayerData.playerMarks,
		"Health": PlayerData.healthStats,
		"Damage": PlayerData.damageStats,
		"Agility": PlayerData.agilityStats,
		"Armor": PlayerData.armorStats,
		"currentPet": PlayerData.currentPet,
		"pets": PlayerData.pets,
		"lockedPets": PlayerData.lockedPets,
		"petAbilities": PlayerData.companionAbilities
	}
	var file := FileAccess.open("user://saveData.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(saveData))

func loadProgress() -> void:
	if FileAccess.file_exists("user://saveData.json"):
		var file := FileAccess.open("user://saveData.json", FileAccess.READ)
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		if data:
			stage = data.get("stage", stage)
			healthBarLength = data.get("healthBarLength", healthBarLength)
			PlayerData.animalTreats = data.get("Treats", PlayerData.animalTreats)
			PlayerData.playerMarks = data.get("Marks", PlayerData.playerMarks)
			PlayerData.healthStats = data.get("Health", PlayerData.healthStats)
			PlayerData.damageStats = data.get("Damage", PlayerData.damageStats)
			PlayerData.agilityStats = data.get("Agility", PlayerData.agilityStats)
			PlayerData.armorStats = data.get("Armor", PlayerData.armorStats)
			PlayerData.currentPet = data.get("currentPet", PlayerData.currentPet)
			PlayerData.pets = data.get("pets", PlayerData.pets)
			PlayerData.lockedPets = data.get("lockedPets", PlayerData.lockedPets)
			PlayerData.companionAbilities = data.get("petAbilities", PlayerData.companionAbilities)
