extends Node

var healthStats := {"value": 100, "level": 1}
var damageStats := {"value": 30, "level": 1}
var agilityStats := {"value": 80, "level": 1}
var armorStats := {"value": 10, "level": 1}

func saveProgress() -> void:
	var saveData := {
		"Health" = healthStats,
		"Damage" = damageStats,
		"Agility" = agilityStats,
		"Armor" = armorStats
	}
	var file := FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(saveData))
