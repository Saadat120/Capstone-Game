extends Node

var healthStats := {"value": 100, "level": 1}
var damageStats := {"value": 30, "level": 1}
var agilityStats := {"value": 80, "level": 1}
var armorStats := {"value": 10, "level": 1}

var playerMarks: int = 20
var animalTreats: int = 3

var currentPet : String = "Wolf"
var pets: Array = ["Stag", "Wolf"]
var lockedPets: Array = ["Stag", "Wolf", "Boar", "Badger"]
var companionAbilities := {
	"Stag": {
		"root": [true],
		"branch1": [true, true],
		"branch2": [false, false]
	},
	"Wolf": {
		"root": [true],
		"branch1": [true, false],
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
	var player := get_tree().get_first_node_in_group("Player")
	if stat == "vitality":
		healthStats["level"] += 1
		if healthStats["level"] == 4:
			healthStats["value"] += 50
			var healthBarLength : int = (GameState.defaultLength * (0.1 * 5))
			GameState.healthBarLength = GameState.defaultLength + healthBarLength
		else:
			healthStats["value"] += (10 * healthStats["level"])
			var healthBarLength : int = (400 * (0.1 * healthStats["level"]))
			GameState.healthBarLength = GameState.defaultLength + healthBarLength
		playerMarks -= cost
		player.playerManager.initHealth()
	elif stat == "damage":
		damageStats["value"] += (10 + 5*(damageStats["level"]-1))
		damageStats["level"] += 1
		playerMarks -= cost
	elif stat == "agility":
		agilityStats["value"] += 10
		agilityStats["level"] += 1
		playerMarks -= cost
	elif stat == "armor":
		armorStats["value"] +=10
		armorStats["level"] += 1
		playerMarks -= cost
