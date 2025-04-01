extends Node

var healthStats := {"value": 100, "level": 1}
var damageStats := {"value": 30, "level": 1}
var agilityStats := {"value": 80, "level": 1}
var armorStats := {"value": 10, "level": 1}
var levelPoints: int = 0
var animalTreats: int = 1
var playerMarks: int = 10

#func _ready() -> void:
	#loadProgress()

func upgradeStat(stat: String, cost: int) -> void:
	if stat == "vitality":
		healthStats["value"] += (10 * healthStats["level"])
		healthStats["level"] += 1
		playerMarks -= cost
	elif stat == "damage":
		damageStats["value"] += (30 * damageStats["level"])/5
		damageStats["level"] += 1
		playerMarks -= cost
	elif stat == "agility":
		agilityStats["value"] += 8
		agilityStats["level"] += 1
		playerMarks -= cost
	elif stat == "armor":
		armorStats["value"] +=10
		armorStats["level"] += 1
		playerMarks -= cost

func saveProgress() -> void:
	var saveData := {
		"Health" = healthStats,
		"Damage" = damageStats,
		"Agility" = agilityStats,
		"Armor" = armorStats
	}
	var file := FileAccess.open("user://saveData.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(saveData))

func loadProgress() -> void:
	if FileAccess.file_exists("user://saveData.json"):
		var file := FileAccess.open("user://saveData.json", FileAccess.READ)
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		if data:
			healthStats = data["Health"]
			damageStats = data["Damage"]
			agilityStats = data["Agility"]
			armorStats = data["Armor"]
			
