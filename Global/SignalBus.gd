extends Node

signal playerHealthChanged(newHealth: int)
signal enemyHealthChanged(newHealth: int)
signal applyBleed()
signal playerEnterArena(player: CharacterBody2D)
signal bossDefeated()

signal insufficientTreats()
signal updateTreatsUI()
