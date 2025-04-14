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
var meterFull: bool = false
var abilityActive := false
@onready var abilitiesManager: AbilitiesManager = $AbilitiesManager
@onready var healthBar: ProgressBar = $"../../UI/PlayerUI/StatsContainer/Container/HealthContainer/HealthBar"
@onready var gaugeMeter: ProgressBar = $"../../UI/PlayerUI/StatsContainer/Container/GaugeContainer/GaugeMeter"

func _ready() -> void:
	canMove = true
	canAttack = true
	gaugeMeter.value = 0
	gaugeMeter.max_value = 100
	maxHealth = PlayerData.healthStats["value"]
	health = maxHealth
	speed = PlayerData.agilityStats["value"]
	armor = PlayerData.armorStats["value"]
	companion = PlayerData.currentPet
	healthBar.initHealth(health)
	SignalBus.playerHealthChanged.connect(healthBar._set_health)

func updateGauge() -> void:
	if gaugeMeter.value < 100 and $AbilitiesManager/UltimateTimer.is_stopped():
		var gaugeInc: float = 100 * (1 + abs((health - 100)/200.0))
		gaugeMeter.value = clamp(gaugeMeter.value + gaugeInc, gaugeMeter.min_value, gaugeMeter.max_value)

func getSpeed() -> float:
	var totalMultiplier := 1.0
	for key:String in speedMultipliers.keys():
		totalMultiplier *= speedMultipliers[key]
	return speed * totalMultiplier

func damage() -> int:
		return abilitiesManager.attack["damage"]

func useAbility(ability: String) -> void:
	match ability:
		"Attack":
			abilitiesManager.canAttack()
		"Dash":
			abilitiesManager.startDash(0.1)
		"Ultimate":
			if gaugeMeter.value >= 100: abilitiesManager.activateUltimate()
