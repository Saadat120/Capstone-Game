extends Node

signal damageApplied(target: CharacterBody2D, damage:int)

func applyDamageToPlayer(source: CharacterBody2D, target: CharacterBody2D) -> void:
	var damageMultiplier = 1/(1+target.playerManager.defence/ 100)
	var damage = max(1, round(source.stats.damage * damageMultiplier))
	target.playerManager.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, false)
	damageApplied.emit(target, damage)

func applyDamageToEnemy(source: CharacterBody2D, target: CharacterBody2D) -> void:
	var damage = source.playerManager.damage()
	target.stats.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, false)
	damageApplied.emit(target, damage)
