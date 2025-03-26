extends Node

func applyDamageToPlayer(source: CharacterBody2D, target: CharacterBody2D) -> void:
	var damageMultiplier: float = 1/(1+target.playerManager.armor/ 100)
	var damage: int = max(1, round(source.stats.damage * damageMultiplier))
	target.playerManager.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, false)

func applyDamageToEnemy(source: CharacterBody2D, target: CharacterBody2D) -> void:
	var damage: int = source.playerManager.damage()
	target.stats.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, false)
