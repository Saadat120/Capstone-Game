class_name PlayerManager extends Node

@export var maxHealth: int
@export var health: int
@export var speed: float
var speedMultipliers := {"Dash": 1, "Ability": 1}
var damageMultiplier := 1
@export var armor: float

@onready var combatManager: CombatManager = $CombatManager
@onready var damageLabel: Label = $"../PlayerUI/HUD/PlayerStats/HBoxContainer/Damage/Label"
@onready var defenceLabel: Label = $"../PlayerUI/HUD/PlayerStats/HBoxContainer/Defence/Label"
@onready var speedLabel: Label = $"../PlayerUI/HUD/PlayerStats/HBoxContainer/Speed/Label"
@onready var healthBar: ProgressBar = $"../PlayerUI/HUD/HealthBar"

func initialize(_maxHealth: int,  _damage: int, _speed: float, _armor: float) -> void:
	maxHealth = _maxHealth
	health = maxHealth
	speed = _speed
	armor = _armor
	healthBar.initHealth(health)
	SignalBus.playerHealthChanged.connect(healthBar._set_health)
	SignalBus.AbilityMeterFilled.connect(applyStagAbility)
	SignalBus.AbilityEnded.connect(endStagAbility)

func _process(_delta: float) -> void:
	damageLabel.text = str(damage())
	defenceLabel.text = str(armor)
	speedLabel.text = str(speed)
	set_process(false)

func getSpeed() -> float:
	var totalMultiplier := 1.0
	for key:String in speedMultipliers.keys():
		totalMultiplier *= speedMultipliers[key]
	return speed * totalMultiplier

func damage() -> int:
	return combatManager.attacks["basicAttack"].damage
	
func getAbility(ability: String) -> Attack:
	return combatManager.attacks[ability]

func performAttack(attackType: String) -> void:
	combatManager.performAttack(attackType)

func applyStagAbility() -> void:
	var healAmount := maxHealth * 0.15
	health = clamp(health+healAmount, 0, maxHealth)
	SignalBus.playerHealthChanged.emit(health)
	speedMultipliers["Ability"] = 1.5
	speedLabel.text = str(getSpeed())

func endStagAbility() -> void:
	speedMultipliers["Ability"] = 1
	speedLabel.text = str(getSpeed())
