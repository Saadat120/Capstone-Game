extends Node

signal damageApplied(target: CharacterBody2D, damage:int)

func applyDamage(source: CharacterBody2D, target: CharacterBody2D) -> void:
	var damage = source.stats.damage
	target.stats.health -= damage
	DamageNumbers.displayNumbers(damage, target.damage_numbers_origin.global_position, false)
	damageApplied.emit(target, damage)
