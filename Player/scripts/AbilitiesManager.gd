class_name AbilitiesManager extends Node

var attack: Dictionary
var dash: Dictionary
var special: Dictionary

func initiialize() -> void:
	attack = {"damage": PlayerData.damageStats["value"], "cooldown": 0.4, "UI": Skill}
	dash = {"cooldown": 2, "UI": Skill}
	attack["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[0]
	dash["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[1]
	
	attack["UI"].call_deferred("initialize", 0.4, "Space")
	dash["UI"].call_deferred("initialize", 2, "Shift")
	
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

func petSpecial() -> void:
	special = {"UI": Skill}
	special["UI"] = get_tree().get_nodes_in_group("PlayerAbilities")[2]
	special["UI"].call_deferred("initialize", 5, "F")
