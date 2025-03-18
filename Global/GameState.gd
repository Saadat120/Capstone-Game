extends Node

var pets: Array = ["Stag"]
var lockedPets: Array = ["Wolf", "Boar", "Badger"]

func unlockPet(name):
	if name not in pets and name in lockedPets:
		pets.append("name")
		lockedPets.erase(name)
