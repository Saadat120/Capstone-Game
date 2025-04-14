class_name PlayerManager extends Node

@export var canMove: bool
@export var canAttack: bool
@export var maxHealth: int
@export var health: int
@export var speed: float
var speedMultipliers := {"Dash": 1, "Ability": 1}
var damageMultiplier := 1
@export var armor: float

var companion: String

@onready var abilitiesManager: AbilitiesManager = $AbilitiesManager
@onready var healthBar: ProgressBar = $"../../UI/PlayerUI/StatsContainer/HealthContainer/HealthBar"

func _ready() -> void:
	canMove = true
	canAttack = true
	maxHealth = PlayerData.healthStats["value"]
	health = maxHealth
	speed = PlayerData.agilityStats["value"]
	armor = PlayerData.armorStats["value"]
	healthBar.initHealth(health)
	SignalBus.playerHealthChanged.connect(healthBar._set_health)
	SignalBus.AbilityMeterFilled.connect(applyStagAbility)
	SignalBus.AbilityEnded.connect(endStagAbility)
	abilitiesManager.initiialize()
	
func getSpeed() -> float:
	var totalMultiplier := 1.0
	for key:String in speedMultipliers.keys():
		totalMultiplier *= speedMultipliers[key]
	return speed * totalMultiplier

func damage() -> int:
		return abilitiesManager.attack["damage"]

func useAbility(ability: String) -> void:
	if ability == "Attack":
		abilitiesManager.canAttack()
	elif ability == "Dash":
		abilitiesManager.startDash(0.1)
	
func applyStagAbility() -> void:
	var healAmount := maxHealth * 0.15
	health = clamp(health+healAmount, 0, maxHealth)
	SignalBus.playerHealthChanged.emit(health)
	speedMultipliers["Ability"] = 1.5

func endStagAbility() -> void:
	speedMultipliers["Ability"] = 1
