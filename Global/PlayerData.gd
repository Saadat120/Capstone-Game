extends Node

var healthStats := {"value": 100, "level": 1}
var damageStats := {"value": 30, "level": 1}
var agilityStats := {"value": 80, "level": 1}
var armorStats := {"value": 10, "level": 1}

var playerMarks: int = 0
var animalTreats: int = 0

var currentPet : String #= "Stag"
var pets: Array #= ["Stag"]
var lockedPets: Array = ["Stag", "Wolf", "Boar", "Badger"]
var companionAbilities := {
	"Stag": {
		"root": [false],
		"branch1": [false, false],
		"branch2": [false, false]
	},
	"Wolf": {
		"root": [false],
		"branch1": [false, false],
		"branch2": [false, false]
	}
}

func unlockPet(petName: String) -> void:
	if petName not in pets and petName in lockedPets:
		pets.append(petName)
		lockedPets.erase(petName)
		companionAbilities[petName]["root"][0] = true

func addTreats(treats: int) -> void: animalTreats += treats
func addMarks(marks: int) -> void: playerMarks += marks

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
