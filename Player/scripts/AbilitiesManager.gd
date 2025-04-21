class_name AbilitiesManager extends Node

var attack: Dictionary
var dash: Dictionary
var special: Dictionary
@onready var attackTimer: Timer = $AttackTimer
@onready var ultimateTimer: Timer = $UltimateTimer
@onready var playerManager: PlayerManager = $".."
var bleedTicks: int = 4
var bleed: bool = false

func _ready() -> void:
	attack = {"damage": 1000, "cooldown": 0.4, "UI": Skill}
	dash = {"cooldown": 2, "UI": Skill}
	special = {"cooldown":5,  "UI": Skill}

	attack["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[0]
	dash["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[1]
	special["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[2]

	attack["UI"].call_deferred("initialize", 0.4, "Space")
	dash["UI"].call_deferred("initialize", 2, "Shift")
	special["UI"].call_deferred("initialize", 5, "F")
	
func canAttack() -> void:
	if $AttackTimer.is_stopped():
		$AttackTimer.start()
		attack["UI"].activateAbility()

func startDash(duration: float) -> void:
	if $DashCooldown.is_stopped():
		$DashTimer.wait_time = duration
		$DashTimer.start()

func isDashing() -> bool:
	return !$DashTimer.is_stopped()
	
func _on_dash_timer_timeout() -> void:
	$DashCooldown.start()
	dash["UI"].activateAbility()

func activateUltimate() -> void:
	if ultimateTimer.is_stopped():
		ultimateTimer.start()
		special["UI"].activateAbility()
		if playerManager.companion == "Stag":
			stagAbility()
		elif playerManager.companion == "Wolf":
			wolfAbility()

func _on_ultimate_timer_timeout() -> void:
	endAbility()

func stagAbility() -> void:
	var healAmount := playerManager.maxHealth * 0.15
	playerManager.health = clamp(playerManager.health+healAmount, 0, playerManager.maxHealth)
	SignalBus.playerHealthChanged.emit(playerManager.health)
	if PlayerData.companionAbilities["Stag"]["branch1"][0]:
		playerManager.speedMultipliers["Ability"] = 1.5
		if PlayerData.companionAbilities["Stag"]["branch1"][1]: 
			playerManager.dodgeCount = 2
	elif PlayerData.companionAbilities["Stag"]["branch2"][0]:
		playerManager.speedMultipliers["Ability"] = 0.5

func wolfAbility() -> void:
	SignalBus.applyBleed.emit()
	if PlayerData.companionAbilities["Wolf"]["branch1"][0]:
		#playerManager.speedMultipliers["Ability"] = 1.5
		if PlayerData.companionAbilities["Wolf"]["branch1"][1]: 
			playerManager.dodgeCount = 3
	elif PlayerData.companionAbilities["Wolf"]["branch2"][0]:
		playerManager.speedMultipliers["Ability"] = 0.5

func endAbility() -> void:
	if playerManager.companion == "Stag":
		endStagAbility()
	elif playerManager.companion == "Wolf":
		endWolfAbility()
	playerManager.gaugeMeter.value = 0

func endStagAbility() -> void:
	playerManager.speedMultipliers["Ability"] = 1
	playerManager.dodgeCount = 0

func endWolfAbility() -> void:
	bleed = false
	bleedTicks = 4

func lifeSteal(enemy: CharacterBody2D) -> void:
	if PlayerData.companionAbilities["Wolf"]["branch1"][0]:
		var steal := int(enemy.stats.maxHealth * 0.005)
		playerManager.health = clamp(playerManager.health+steal, 0, playerManager.maxHealth)
