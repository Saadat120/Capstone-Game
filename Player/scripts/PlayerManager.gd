class_name PlayerManager extends Node

@export var maxHealth: int
@export var health: int
@export var speed: float
var speedMultiplier = 1
@export var defence: float
@onready var combatManager: CombatManager = $CombatManager


func initialize(_maxHealth,  _damage, _speed, _defence):
	maxHealth = _maxHealth
	health = maxHealth
	speed = _speed
	defence = _defence

func getSpeed():
	return speed * speedMultiplier

func damage():
	return combatManager.attacks["basicAttack"].damage
	
func getAbility(ability: String):
	return combatManager.attacks[ability]

func performAttack(attackType: String):
	combatManager.performAttack(attackType)
