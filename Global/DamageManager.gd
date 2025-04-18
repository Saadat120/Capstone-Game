extends Node

func applyDamageToPlayer(enemy: CharacterBody2D, player: CharacterBody2D) -> void:
	var damageMultiplier: float = 1/(1+player.playerManager.armor/ 100)
	var damage: int = max(1, round(enemy.stats.damage * damageMultiplier))
	player.playerManager.health -= damage
	DamageNumbers.displayNumbers(damage, player.damage_numbers_origin.global_position, false)

func applyDamageToEnemy(player: CharacterBody2D, enemy: CharacterBody2D) -> void:
	player.recentHit = true
	var damage: int = player.playerManager.damage()
	enemy.stats.health -= damage
	DamageNumbers.displayNumbers(damage, enemy.damage_numbers_origin.global_position, false)

func applyBleed(target: CharacterBody2D) -> void:
	var damage: int = max(1, int(target.stats.maxHealth * 0.01))
	target.stats.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, true)
