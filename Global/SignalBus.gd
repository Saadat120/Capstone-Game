extends Node

signal playerHealthChanged(newHealth: int)
signal activateSkill(button: String)
signal passiveStack()
signal AbilityMeterFilled()
signal AbilityEnded()
signal enemyHealthChanged(newHealth: int)
signal applyBleed(target: CharacterBody2D, damagePerSec: int, timeEffect: int)
signal playerEnterArena(player: CharacterBody2D)
signal bossDefeated()

signal insufficientTreats()
signal updateTreatsUI()
